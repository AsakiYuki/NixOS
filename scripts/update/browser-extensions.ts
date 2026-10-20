import "dotenv/config"
import fs from "node:fs/promises"
import path from "node:path"

import {
	fetchChromeExtension,
	fetchFirefoxAddon,
	getLocalized,
	type BrowserExtensions,
	type FirefoxAddon,
} from "../helpers/browser-extensions"

function getFirefoxMetadata(data: Awaited<ReturnType<typeof fetchFirefoxAddon>>): Record<string, string> {
	const locale = data.default_locale
	const metadata: Record<string, string> = {
		name: getLocalized(data.name, locale),
		description: getLocalized(data.summary, locale),
		homepage: getLocalized(data.homepage?.url, locale),
		license: getLocalized(data.current_version.license?.name, locale),
		author: data.authors?.[0]?.name || "",
	}

	return Object.fromEntries(Object.entries(metadata).filter(([, value]) => value.trim() !== ""))
}

async function updateFirefoxAddons(
	addons: Record<string, FirefoxAddon>,
	updates: string[],
): Promise<void> {
	await Promise.all(Object.entries(addons).map(async ([name, addon]) => {
		console.info(`[INFO] Checking Firefox addon ${name}...`)
		const data = await fetchFirefoxAddon(addon.id || name)
		if (data.current_version.version === addon.version && addon.meta?.description && addon.id) return

		const [algorithm, hexHash] = data.current_version.file.hash.split(/[:\-]/)
		const hash = `${algorithm}-${Buffer.from(hexHash, "hex").toString("base64")}`
		const metadata = getFirefoxMetadata(data)

		addons[name] = {
			...addon,
			id: addon.id || data.guid,
			version: data.current_version.version,
			src: { url: data.current_version.file.url, hash },
			meta: { ...metadata, ...addon.meta },
		}
		updates.push(`${name} - ${data.guid} ${data.current_version.version} - Hash: ${hash}`)
		console.info(`[UPDATE] Firefox addon ${name}: ${data.current_version.version}`)
	}))
}

async function updateChromeExtensions(
	extensions: BrowserExtensions["chrome"],
	updates: string[],
): Promise<void> {
	await Promise.all(Object.entries(extensions).map(async ([name, extension]) => {
		console.info(`[INFO] Checking Chrome extension ${name}...`)
		const latest = await fetchChromeExtension(extension.id)
		if (
			latest.version === extension.version
			&& latest.src.url === extension.src.url
			&& latest.src.hash === extension.src.hash
		) {
			console.info(`[SKIP] ${name} is already up to date (${latest.version}).`)
			return
		}

		extensions[name] = { ...extension, ...latest }
		updates.push(`${name} ${latest.version} - Hash: ${latest.src.hash}`)
		console.info(`[UPDATE] Chrome extension ${name}: ${extension.version} -> ${latest.version}`)
	}))
}

async function main() {
	const catalogPath = path.join(__dirname, "../../assets/browser.extensions.json")
	const commitPath = path.join(__dirname, "../../browser-extensions-commit.txt")
	const catalog: BrowserExtensions = JSON.parse(await fs.readFile(catalogPath, "utf-8"))
	const updates: string[] = []

	await Promise.all([
		updateFirefoxAddons(catalog.firefox, updates),
		updateChromeExtensions(catalog.chrome, updates),
	])

	if (updates.length === 0) {
		await fs.rm(commitPath, { force: true })
		console.info("[INFO] No browser extension updates found.")
		return
	}

	await Promise.all([
		fs.writeFile(catalogPath, JSON.stringify(catalog, null, 4) + "\n", "utf-8"),
		fs.writeFile(commitPath, updates.join("\n") + "\n", "utf-8"),
	])
	console.info(`[INFO] Updated ${updates.length} browser extension(s).`)
}

main().catch(error => {
	console.error(error)
	process.exitCode = 1
})
