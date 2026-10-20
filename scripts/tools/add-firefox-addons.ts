import {
	fetchFirefoxAddon,
	getLocalized,
	type BrowserExtensions,
} from "../helpers/browser-extensions"
import { runScript } from "../helpers/cli"
import { readSourceData, writeSourceData } from "../helpers/source-data"

async function main(...args: string[]) {
	const addonNameRegex = /(?<=(https|http):\/\/addons.mozilla.org\/\w+-\w+\/firefox\/addon\/)(\w|-)+/
	const isAddonNameRegex = /^(\w|-)+$/

	const sourceData = await readSourceData()
	const extensions: BrowserExtensions = {
		firefox: sourceData.extensions.firefox,
		chrome: sourceData.extensions.chrome,
	}
	const firefoxAddons = extensions.firefox

	await Promise.all(
		(
			args
				.map(addon => {
					if (addonNameRegex.test(addon)) addon = addon.match(addonNameRegex)?.[0]!
					if (!isAddonNameRegex.test(addon)) return null
					return addon
				})
				.filter(addon => addon !== null && !firefoxAddons[addon]) as string[]
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

			firefoxAddons[addon] = {
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

	await writeSourceData(sourceData)
}

runScript(() => main(...process.argv.slice(2)))
