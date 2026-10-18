import "dotenv/config"
import { createHash } from "crypto"
import fs from "fs/promises"
import path from "path"
import { VSCE } from "../helpers/vsce"

const targetPlatforms = [
	"linux-x64",
	"linux-arm64",
	"linux-armhf",
	"linux-ppc64le",
	"linux-s390x",
	"alpine-x64",
	"alpine-arm64",
	"darwin-x64",
	"darwin-arm64",
	"win32-x64",
	"win32-arm64",
	"win32-ia32",
]

type ExtensionSource = {
	version: string
	checkedPlatforms?: boolean
	hash: Record<string, string>
}

async function hashVsix(id: string, version: string, targetPlatform?: string): Promise<string | null> {
	const [publisher, ...nameParts] = id.split(".")
	if (!publisher || nameParts.length === 0) throw new Error(`Invalid extension ID: ${id}`)

	const name = nameParts.join(".")
	const query = targetPlatform ? `?targetPlatform=${encodeURIComponent(targetPlatform)}` : ""
	const url = `https://${publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${publisher}/extension/${name}/${version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage${query}`
	try {
		const response = await fetch(url, { signal: AbortSignal.timeout(90_000) })
		if (response.status === 400 || response.status === 404 || response.status === 500) return null
		if (!response.ok || !response.body) {
			throw new Error(`Failed to download ${id} v${version} (${targetPlatform ?? "universal"}): HTTP ${response.status}`)
		}

		const hash = createHash("sha256")
		for await (const chunk of response.body) hash.update(chunk)
		return `sha256-${hash.digest("base64")}`
	} catch (error) {
		console.warn(`[WARN] Timed out or failed to hash ${id} (${targetPlatform ?? "universal"}): ${String(error)}`)
		return null
	}
}

async function main() {
	const filepath = path.join(__dirname, "../../assets/vscode.extensions.json")
	const commitFilepath = path.join(__dirname, "../../vscode-extensions-commit.txt")
	const data: Record<string, Record<string, any>> = JSON.parse(await fs.readFile(filepath, "utf-8"))
	const commits: string[] = []

	for (const [publisher, extensions] of Object.entries(data)) {
		for (const [name, info] of Object.entries(extensions)) {
			const id = `${publisher}.${name}`
			console.info(`[INFO] Fetching ${id}`)
			let extInfo
			try {
				extInfo = await VSCE.show(id)
			} catch (error) {
				console.warn(`[WARN] Could not fetch Marketplace metadata for ${id}; skipping: ${String(error)}`)
				continue
			}

			const currentVersion = extInfo.versions[0]
			if (!currentVersion) {
				console.warn(`[WARN] Marketplace returned no versions for ${id}; skipping.`)
				continue
			}
			if (info.src?.version === currentVersion.version && info.src?.checkedPlatforms) {
				const platformList = Object.keys(info.src.hash ?? {}).join(", ")
				console.info(`[SKIP] ${id} already has platform hashes (${platformList})`)
				continue
			}

			const source: ExtensionSource = {
				version: currentVersion.version,
				hash: {},
			}
			const properties = VSCE.standardizeProperties(currentVersion.properties)
			const universalHash = id === "redhat.java"
				? await VSCE.hashVersionedVsix(id, currentVersion.version)
				: properties["Microsoft.VisualStudio.Services.VsixSha256"]
					? VSCE.toSriHash(properties["Microsoft.VisualStudio.Services.VsixSha256"])
					: await hashVsix(id, currentVersion.version)
			if (universalHash) source.hash.universal = universalHash

			const available = await Promise.all(targetPlatforms.map(async targetPlatform => {
				const hash = await hashVsix(id, currentVersion.version, targetPlatform)
				return hash ? [targetPlatform, hash] as const : null
			}))
			for (const entry of available) {
				if (entry) source.hash[entry[0]] = entry[1]
			}

			if (Object.keys(source.hash).length === 0) {
				console.warn(`[WARN] Marketplace returned no downloadable VSIX for ${id}; skipping.`)
				continue
			}
			source.checkedPlatforms = true

			data[publisher][name] = {
				src: source,
				meta: {
					description: extInfo.shortDescription,
					homepage: properties["Microsoft.VisualStudio.Services.Links.Learn"],
					downloadPage: `https://marketplace.visualstudio.com/items?itemName=${id}`,
				},
			}

			const platformList = Object.keys(source.hash).join(", ")
			console.info(`[SUCCESS] Updated ${id} to v${currentVersion.version} (${platformList})`)
			commits.push(`${id} ${currentVersion.version} - Platforms: ${platformList}`)
			await fs.writeFile(filepath, JSON.stringify(data, null, 4), "utf-8")
		}
	}

	if (commits.length === 0) {
		await fs.rm(commitFilepath, { force: true })
		console.info(`[INFO] No VS Code extension updates found.`)
		return
	}

	await Promise.all([
		fs.writeFile(filepath, JSON.stringify(data, null, 4), "utf-8"),
		fs.writeFile(commitFilepath, commits.join("\n")),
	])
}

main().catch(error => {
	console.error(error)
	process.exitCode = 1
})
