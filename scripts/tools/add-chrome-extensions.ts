import fs from "node:fs/promises"
import path from "node:path"

import { fetchChromeExtension, type BrowserExtensions } from "../helpers/browser-extensions"

const chromeIdPattern = /^[a-p]{32}$/
const packageNamePattern = /^[a-z0-9]+(?:-[a-z0-9]+)*$/

async function main(args: string[]): Promise<void> {
	if (args.length === 0 || args.length % 3 !== 0) {
		throw new Error(
			"Usage: add-chrome-extensions <package-name> <chrome-extension-id> <managed-settings-json> [...]",
		)
	}

	const filepath = path.join(__dirname, "../../assets/browser.extensions.json")
	const catalog: BrowserExtensions = JSON.parse(await fs.readFile(filepath, "utf-8"))
	let added = 0

	for (let index = 0; index < args.length; index += 3) {
		const [name, id, settingsJson] = args.slice(index, index + 3)
		if (!packageNamePattern.test(name)) throw new Error(`Invalid package name: ${name}`)
		if (!chromeIdPattern.test(id)) throw new Error(`Invalid Chrome extension ID: ${id}`)
		if (catalog.chrome[name]) {
			console.info(`[SKIP] ${name} is already in the Chrome extension catalog`)
			continue
		}

		let managedSettings: unknown
		try {
			managedSettings = JSON.parse(settingsJson)
		} catch {
			throw new Error(`Invalid managed settings JSON for ${name}`)
		}
		if (!managedSettings || typeof managedSettings !== "object" || Array.isArray(managedSettings)) {
			throw new Error(`Managed settings for ${name} must be a JSON object`)
		}

		console.info(`[INFO] Fetching Chrome extension ${name} (${id})`)
		const release = await fetchChromeExtension(id)
		catalog.chrome[name] = {
			id,
			...release,
			meta: { name },
			managedSettings: managedSettings as Record<string, unknown>,
		}
		console.info(`[SUCCESS] Added ${name} v${release.version}`)
		added++
	}

	const temporaryPath = `${filepath}.tmp`
	await fs.writeFile(temporaryPath, `${JSON.stringify(catalog, null, 4)}\n`, "utf-8")
	await fs.rename(temporaryPath, filepath)
	console.info(`[INFO] Added ${added} Chrome extension(s)`)
}

main(process.argv.slice(2)).catch(error => {
	console.error(error)
	process.exitCode = 1
})
