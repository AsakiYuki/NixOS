import "dotenv/config"
import fs from "fs/promises"
import path from "path"

import { fetchFirefoxAddon } from "../helpers/firefox.addons"

export interface FirefoxAddon {
	version: string
	id: string
	src: {
		url: string
		hash: string
	}
	meta?: Record<string, string>
}

function getLocalized(record?: Record<string, string | null>, defaultLocale?: string): string {
	if (!record) return ""
	return record["en-US"] || (defaultLocale && record[defaultLocale]) || Object.values(record)[0] || ""
}

async function main() {
	const firefoxAddonsData = path.join(__dirname, "../../assets/firefox.addons.json")
	const addons: Record<string, FirefoxAddon> = JSON.parse(await fs.readFile(firefoxAddonsData, "utf-8"))
	const commits: string[] = []

	console.log(`[INFO] Checking update for firefox addons...`)

	await Promise.all(
		Object.entries(addons).map(async ([name, currentAddon]) => {
			const data = await fetchFirefoxAddon(currentAddon.id ?? name)
			const isSameVersion = data.current_version.version === currentAddon.version

			if (isSameVersion && currentAddon.meta?.description && currentAddon.id) return null

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

			addons[name] = {
				...currentAddon,
				version: data.current_version.version,
				id: currentAddon.id ?? data.guid,
				src: {
					url: data.current_version.file.url,
					hash,
				},
				meta: {
					...cleanMeta,
					...(currentAddon.meta || {}),
				},
			}
			console.log(`[INFO] New update found: ${name} - ${data.current_version.version} - ${hash}`)
			commits.push(`${data.guid} ${data.current_version.version} - Hash: ${hash}`)
		}),
	)

	if (commits.length === 0) return
	console.log(`[INFO] ${commits.length} addon(s) updated!`)
	await Promise.all([
		fs.writeFile(firefoxAddonsData, JSON.stringify(addons, null, 4), "utf-8"),
		fs.writeFile(path.join(__dirname, "../../firefox-addons-commit.txt"), commits.join("\n"), "utf-8"),
	])
}

main()
