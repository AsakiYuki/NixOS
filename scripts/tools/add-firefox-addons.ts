import path from "node:path"
import fs from "fs/promises"

import { fetchFirefoxAddon } from "../helpers/firefox.addons"
import { FirefoxAddon } from "../update/firefox-addons"

export function getLocalized(record?: Record<string, string | null>, defaultLocale?: string): string {
	if (!record) return ""
	return record["en-US"] || (defaultLocale && record[defaultLocale]) || Object.values(record)[0] || ""
}

async function main(...args: string[]) {
	const addonNameRegex = /(?<=(https|http):\/\/addons.mozilla.org\/\w+-\w+\/firefox\/addon\/)(\w|-)+/
	const isAddonNameRegex = /^(\w|-)+$/

	const filepath = path.join(__dirname, "../../assets/firefox.addons.json")
	const firefoxAddon: Record<string, FirefoxAddon> = JSON.parse(await fs.readFile(filepath, "utf-8"))

	await Promise.all(
		(
			args
				.map(addon => {
					if (addonNameRegex.test(addon)) addon = addon.match(addonNameRegex)?.[0]!
					if (!isAddonNameRegex.test(addon)) return null
					return addon
				})
				.filter(addon => addon !== null && !firefoxAddon[addon]) as string[]
		).map(async addon => {
			const data = await fetchFirefoxAddon(addon)

			const [algo, hex] = data.current_version.file.hash.split(/[:\-]/)
			const base64 = Buffer.from(hex, "hex").toString("base64")
			const locale = data.default_locale

			const fetchedMeta: Record<string, string> = {
				name: getLocalized(data.name, locale),
				description: getLocalized(data.summary, locale),
				homepage: getLocalized(data.homepage?.url, locale),
				license: getLocalized(data.current_version.license?.name, locale),
				author: data.authors?.[0]?.name || "",
			}

			const cleanMeta = Object.fromEntries(Object.entries(fetchedMeta).filter(([_, v]) => v.trim() !== ""))
			const hash = `${algo}-${base64}`

			firefoxAddon[addon] = {
				version: data.current_version.version,
				id: data.guid,
				src: {
					url: data.current_version.file.url,
					hash,
				},
				meta: cleanMeta,
			}

			console.log(`[INFO] Added firefox addon: ${addon} - ${data.current_version.version} - ${hash}`)
		}),
	)

	await fs.writeFile(filepath, JSON.stringify(firefoxAddon, null, 4), "utf-8")
}

main(...process.argv.slice(2))
