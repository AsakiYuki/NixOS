import fs from "node:fs/promises"
import path from "node:path"

interface ChromeExtension {
	id: string
	version: string
	src: {
		url: string
		hash: string
	}
	meta?: Record<string, string>
	managedSettings: Record<string, unknown>
}

function parseAttributes(value: string): Record<string, string> {
	return Object.fromEntries(
		Array.from(value.matchAll(/([\w-]+)="([^"]*)"/g), ([, key, item]) => [key, item]),
	)
}

function toSriHash(hex: string): string {
	if (!/^[\da-f]{64}$/i.test(hex)) throw new Error(`Invalid SHA-256 from update manifest: ${hex}`)
	return `sha256-${Buffer.from(hex, "hex").toString("base64")}`
}

async function fetchLatestExtension(id: string) {
	const url = new URL("https://clients2.google.com/service/update2/crx")
	url.searchParams.set("response", "updatecheck")
	url.searchParams.set("prodversion", "155.0.0.0")
	url.searchParams.set("acceptformat", "crx3")
	url.searchParams.set("x", `id=${id}&installsource=ondemand&uc`)

	const response = await fetch(url, {
		headers: { "User-Agent": "Mozilla/5.0 (compatible; NixChromiumExtensionUpdater/1.0)" },
		signal: AbortSignal.timeout(60_000),
	})
	if (!response.ok) throw new Error(`Chrome update service returned HTTP ${response.status} for ${id}`)

	const xml = await response.text()
	const match = xml.match(/<updatecheck\b([^>]*)\/?\s*>/)
	if (!match) throw new Error(`Chrome update service returned no updatecheck for ${id}`)

	const attributes = parseAttributes(match[1])
	if (attributes.status !== "ok") throw new Error(`No compatible update found for ${id} (status: ${attributes.status ?? "missing"})`)
	if (!attributes.version || !attributes.codebase || !attributes.hash_sha256) {
		throw new Error(`Chrome update service returned incomplete metadata for ${id}`)
	}

	return {
		version: attributes.version,
		src: {
			url: attributes.codebase,
			hash: toSriHash(attributes.hash_sha256),
		},
	}
}

async function main() {
	const assetPath = path.join(__dirname, "../../assets/chrome.extensions.json")
	const commitPath = path.join(__dirname, "../../chrome-extensions-commit.txt")
	const extensions: Record<string, ChromeExtension> = JSON.parse(await fs.readFile(assetPath, "utf-8"))
	const updates: string[] = []

	await Promise.all(Object.entries(extensions).map(async ([name, extension]) => {
		console.info(`[INFO] Checking Chrome extension ${name}...`)
		if (!extension.managedSettings || Object.keys(extension.managedSettings).length === 0) {
			throw new Error(`${name} has no verified Chrome managed settings; refusing to add an unconfigurable extension.`)
		}

		const latest = await fetchLatestExtension(extension.id)
		if (latest.version === extension.version && latest.src.url === extension.src.url && latest.src.hash === extension.src.hash) {
			console.info(`[SKIP] ${name} is already up to date (${latest.version}).`)
			return
		}

		console.info(`[UPDATE] ${name}: ${extension.version} -> ${latest.version}`)
		extensions[name] = { ...extension, ...latest }
		updates.push(`${name} ${latest.version} - Hash: ${latest.src.hash}`)
	}))

	if (updates.length === 0) {
		await fs.rm(commitPath, { force: true })
		console.info("[INFO] No Chrome extension updates found.")
		return
	}

	await Promise.all([
		fs.writeFile(assetPath, JSON.stringify(extensions, null, 4) + "\n", "utf-8"),
		fs.writeFile(commitPath, updates.join("\n") + "\n", "utf-8"),
	])
}

main().catch(error => {
	console.error(error)
	process.exitCode = 1
})
