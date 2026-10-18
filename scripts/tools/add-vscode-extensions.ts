import { createHash } from "node:crypto"
import fs from "node:fs/promises"
import path from "node:path"

import { VSCE, type ExtensionInfo } from "../helpers/vsce"

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
] as const

type Platform = "universal" | (typeof targetPlatforms)[number]

interface ExtensionRecord {
	src: {
		version: string
		checkedPlatforms: true
		hash: Partial<Record<Platform, string>>
	}
	meta: Record<string, string>
}

type ExtensionCatalog = Record<string, Record<string, ExtensionRecord>>

const extensionIdPattern = /^[\w-]+\.[\w-]+$/

function normalizeId(candidate: string): string | null {
	const id = candidate.trim().replace(/^["']|["']$/g, "").replace(/[),.;]+$/, "")
	return extensionIdPattern.test(id) ? id.toLowerCase() : null
}

function parseExtensionIds(input: string): string[] {
	const value = input.trim()
	if (!value || value === "--") return []

	try {
		const url = new URL(value)
		if (url.hostname.toLowerCase() === "marketplace.visualstudio.com") {
			const id = url.searchParams.get("itemName")
			return id ? [normalizeId(id)].filter((value): value is string => value !== null) : []
		}
	} catch {
		// The input may be an extension ID or an install command instead of a URL.
	}

	const commandMatches = [...value.matchAll(/(?:--install-extension|\bext\s+install)\s+["']?([\w-]+\.[\w-]+)/gi)]
	if (commandMatches.length > 0) {
		return commandMatches
			.map(match => normalizeId(match[1]))
			.filter((id): id is string => id !== null)
	}

	const uriMatch = value.match(/\bvscode(?:-insiders)?:extension\/([\w-]+\.[\w-]+)/i)
	if (uriMatch) {
		const id = normalizeId(uriMatch[1])
		return id ? [id] : []
	}

	const itemNameMatch = value.match(/(?:[?&]|^)itemName=([\w-]+\.[\w-]+)/i)
	if (itemNameMatch) {
		const id = normalizeId(itemNameMatch[1])
		return id ? [id] : []
	}

	const id = normalizeId(value)
	return id ? [id] : []
}

async function hashVsix(id: string, version: string, targetPlatform?: string): Promise<string | null> {
	const [publisher, ...extensionParts] = id.split(".")
	const name = extensionParts.join(".")
	const query = targetPlatform ? `?targetPlatform=${encodeURIComponent(targetPlatform)}` : ""
	const url = `https://${publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${publisher}/extension/${name}/${version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage${query}`
	const response = await fetch(url, { signal: AbortSignal.timeout(90_000) })

	if ([400, 404, 500].includes(response.status)) return null
	if (!response.ok || !response.body) {
		throw new Error(`Failed to download ${id} v${version} (${targetPlatform ?? "universal"}): HTTP ${response.status}`)
	}

	const hash = createHash("sha256")
	for await (const chunk of response.body) hash.update(chunk)
	return `sha256-${hash.digest("base64")}`
}

function makeMetadata(extInfo: ExtensionInfo, properties: Record<string, string>, id: string): Record<string, string> {
	const metadata: Record<string, string> = {
		downloadPage: `https://marketplace.visualstudio.com/items?itemName=${id}`,
	}
	if (extInfo.shortDescription) metadata.description = extInfo.shortDescription
	const homepage = properties["Microsoft.VisualStudio.Services.Links.Learn"]
	if (homepage) metadata.homepage = homepage
	return metadata
}

async function readCatalog(filepath: string): Promise<ExtensionCatalog> {
	const content = await fs.readFile(filepath, "utf-8")
	const parsed: unknown = JSON.parse(content)
	if (!parsed || typeof parsed !== "object" || Array.isArray(parsed)) {
		throw new Error(`${filepath} must contain a JSON object`)
	}
	return parsed as ExtensionCatalog
}

async function writeCatalog(filepath: string, catalog: ExtensionCatalog): Promise<void> {
	const temporaryPath = `${filepath}.tmp`
	await fs.writeFile(temporaryPath, `${JSON.stringify(catalog, null, 4)}\n`, "utf-8")
	await fs.rename(temporaryPath, filepath)
}

async function addExtension(id: string, catalog: ExtensionCatalog, filepath: string): Promise<boolean> {
	const [publisher, ...extensionParts] = id.split(".")
	const name = extensionParts.join(".")
	if (catalog[publisher]?.[name]) {
		console.info(`[SKIP] ${id} is already in the catalog`)
		return false
	}

	console.info(`[INFO] Fetching ${id} from the Marketplace`)
	const extInfo = await VSCE.show(id)
	const currentVersion = extInfo.versions[0]
	if (!currentVersion) throw new Error(`Marketplace returned no versions for ${id}`)

	const properties = VSCE.standardizeProperties(currentVersion.properties)
	const source: ExtensionRecord["src"] = {
		version: currentVersion.version,
		hash: {},
		checkedPlatforms: true,
	}

	const marketplaceHash = properties["Microsoft.VisualStudio.Services.VsixSha256"]
	const universalHash = id === "redhat.java"
		? await hashVsix(id, currentVersion.version)
		: marketplaceHash
			? VSCE.toSriHash(marketplaceHash)
			: await hashVsix(id, currentVersion.version)
	if (universalHash) source.hash.universal = universalHash

	const platformHashes = await Promise.all(
		targetPlatforms.map(async platform => [platform, await hashVsix(id, currentVersion.version, platform)] as const),
	)
	for (const [platform, hash] of platformHashes) {
		if (hash) source.hash[platform] = hash
	}

	if (Object.keys(source.hash).length === 0) {
		throw new Error(`Marketplace returned no universal or platform VSIX for ${id}`)
	}

	catalog[publisher] ??= {}
	catalog[publisher][name] = {
		src: source,
		meta: makeMetadata(extInfo, properties, id),
	}
	await writeCatalog(filepath, catalog)

	const platformList = Object.keys(source.hash).join(", ")
	console.info(`[SUCCESS] Added ${id} v${currentVersion.version} (${platformList})`)
	return true
}

async function main(args: string[]): Promise<void> {
	const ids = [...new Set(args.flatMap(parseExtensionIds))]
	const commandTokens = /^(?:--|--install-extension|code(?:-insiders)?|codium(?:-insiders)?|ext|install)$/i
	const invalidArgs = args.filter(arg => !commandTokens.test(arg) && parseExtensionIds(arg).length === 0)
	if (invalidArgs.length > 0) {
		for (const arg of invalidArgs) console.warn(`[WARN] Could not find an extension ID in: ${arg}`)
	}
	if (ids.length === 0) {
		throw new Error("Usage: add-vscode-extensions <publisher.extension | Marketplace URL | install command> [...]")
	}

	const filepath = path.join(__dirname, "../../assets/vscode.extensions.json")
	const catalog = await readCatalog(filepath)
	let added = 0

	for (const id of ids) {
		if (await addExtension(id, catalog, filepath)) added++
	}

	console.info(`[INFO] Added ${added} extension(s)`)
}

main(process.argv.slice(2)).catch(error => {
	console.error(error)
	process.exitCode = 1
})
