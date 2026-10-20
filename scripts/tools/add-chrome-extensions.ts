import { fetchChromeExtension, type BrowserExtensions } from "../helpers/browser-extensions"
import { runScript } from "../helpers/cli"
import { readSourceData, writeSourceData } from "../helpers/source-data"

const chromeIdPattern = /^[a-p]{32}$/

function decodeHtml(value: string): string {
	return value.replace(/&(#x[\da-f]+|#\d+|amp|quot|apos|#39|lt|gt);/gi, (entity, code: string) => {
		if (code[0] === "#") {
			const number = code[1].toLowerCase() === "x"
				? Number.parseInt(code.slice(2), 16)
				: Number.parseInt(code.slice(1), 10)
			return Number.isFinite(number) ? String.fromCodePoint(number) : entity
		}

		return ({ amp: "&", quot: '"', apos: "'", "#39": "'", lt: "<", gt: ">" })[code.toLowerCase()] ?? entity
	})
}

function getMetaContent(html: string, property: string): string | undefined {
	for (const [tag] of html.matchAll(/<meta\b[^>]*>/gi)) {
		const attributes = Object.fromEntries(
			Array.from(tag.matchAll(/([\w:-]+)\s*=\s*(["'])(.*?)\2/g), ([, name, , value]) => [name.toLowerCase(), value]),
		)
		if (attributes.property === property || attributes.name === property) return decodeHtml(attributes.content ?? "")
	}
}

function getExtensionId(input: string): string {
	if (chromeIdPattern.test(input)) return input

	let url: URL
	try {
		url = new URL(input)
	} catch {
		throw new Error(`Expected a Chrome Web Store URL or extension ID, got: ${input}`)
	}

	if (![
		"chromewebstore.google.com",
		"chrome.google.com",
	].includes(url.hostname)) {
		throw new Error(`Not a Chrome Web Store URL: ${input}`)
	}

	const id = url.pathname.split("/").filter(Boolean).at(-1)
	if (!id || !chromeIdPattern.test(id)) throw new Error(`Could not read a Chrome extension ID from: ${input}`)
	return id
}

interface StoreSearchResult {
	name: string
	id: string
	publisher?: string
}

function getStoreSearchResults(html: string): StoreSearchResult[] {
	const results: StoreSearchResult[] = []
	const cards = [...html.matchAll(/data-item-id=["']([a-p]{32})["']/gi)]

	for (const [index, card] of cards.entries()) {
		const id = card[1]
		const start = card.index! + card[0].length
		const end = cards[index + 1]?.index ?? html.length
		const content = html.slice(start, end)
		const heading = content.match(/<h2\b[^>]*>([\s\S]*?)<\/h2>/i)?.[1]
		if (!heading) continue

		const name = decodeHtml(heading.replace(/<[^>]+>/g, "")).trim()
		const publisher = content.match(/<span\b[^>]*class=["'][^"']*cJI8ee[^"']*["'][^>]*>([^<]+)<\/span>/i)?.[1]
		if (name && !results.some(result => result.id === id)) {
			results.push({ name, id, publisher: publisher ? decodeHtml(publisher).trim() : undefined })
		}
	}

	return results
}

function normalizeName(name: string): string {
	return name.toLocaleLowerCase().replace(/[^\p{L}\p{N}]+/gu, " ").trim()
}

function getTrustedFirefoxHosts(input: string, catalog: BrowserExtensions): string[] {
	return Object.values(catalog.firefox)
		.filter(addon => normalizeName(addon.meta?.name ?? "") === normalizeName(input))
		.flatMap(addon => {
			try {
				return addon.meta?.homepage ? [new URL(addon.meta.homepage).hostname] : []
			} catch {
				return []
			}
		})
}

function getFirefoxPackageName(input: string, catalog: BrowserExtensions): string | undefined {
	return Object.entries(catalog.firefox)
		.find(([, addon]) => normalizeName(addon.meta?.name ?? "") === normalizeName(input))?.[0]
}

async function resolveExtensionId(input: string, catalog: BrowserExtensions): Promise<string> {
	if (chromeIdPattern.test(input)) return input
	if (/^https?:\/\//i.test(input)) return getExtensionId(input)

	const searchUrl = `https://chromewebstore.google.com/search/${encodeURIComponent(input.trim())}`
	const response = await fetch(searchUrl, {
		headers: { "User-Agent": "Mozilla/5.0 (compatible; NixBrowserExtensionUpdater/1.0)" },
		signal: AbortSignal.timeout(60_000),
	})
	if (!response.ok) throw new Error(`Chrome Web Store search returned HTTP ${response.status} for ${input}`)

	const results = getStoreSearchResults(await response.text())
	const exactMatches = results.filter(result => normalizeName(result.name) === normalizeName(input))

	const trustedHosts = getTrustedFirefoxHosts(input, catalog)
	if (trustedHosts.length > 0) {
		const trustedMatches = results.filter(result => {
			if (!result.publisher) return false
			const publisher = result.publisher.toLowerCase().replace(/^www\./, "")
			return trustedHosts.some(host => {
				const trustedHost = host.toLowerCase().replace(/^www\./, "")
				return publisher === trustedHost || publisher.endsWith(`.${trustedHost}`)
			})
		})
		const stableMatches = trustedMatches.filter(result => !/\b(beta|nightly|dev|canary)\b/i.test(result.name))
		if (stableMatches.length === 1) return stableMatches[0].id
		if (stableMatches.length > 1) {
			throw new Error(`More than one extension from ${trustedHosts[0]} matches "${input}". Pass a store URL instead.`)
		}
	}
	if (exactMatches.length === 1) return exactMatches[0].id

	const choices = (exactMatches.length > 0 ? exactMatches : results.slice(0, 5))
		.map(result => `  ${result.name}: https://chromewebstore.google.com/detail/${result.id}`)
		.join("\n")
	if (exactMatches.length > 1) {
		throw new Error(`More than one extension matches "${input}". Pass a store URL instead:\n${choices}`)
	}
	if (results.length > 0) {
		throw new Error(`No exact Chrome Web Store match for "${input}". Pick a result URL:\n${choices}`)
	}
	throw new Error(`No Chrome Web Store results found for "${input}"`)
}

function makePackageName(name: string): string {
	const packageName = name
		.normalize("NFKD")
		.replace(/[\u0300-\u036f]/g, "")
		.toLowerCase()
		.replace(/[^a-z0-9]+/g, "-")
		.replace(/^-|-$/g, "")

	if (!packageName) throw new Error(`Could not make a Nix package name from extension name: ${name}`)
	return packageName
}

async function fetchStoreMetadata(id: string): Promise<{ name: string; description?: string }> {
	const url = `https://chromewebstore.google.com/detail/${id}`
	const response = await fetch(url, {
		headers: { "User-Agent": "Mozilla/5.0 (compatible; NixBrowserExtensionUpdater/1.0)" },
		signal: AbortSignal.timeout(60_000),
	})
	if (!response.ok) throw new Error(`Chrome Web Store returned HTTP ${response.status} for ${id}`)

	const html = await response.text()
	const title = getMetaContent(html, "og:title") ?? html.match(/<title[^>]*>(.*?)<\/title>/i)?.[1]
	const name = title?.replace(/\s*-\s*Chrome Web Store\s*$/i, "").trim()
	if (!name) throw new Error(`Chrome Web Store returned no extension name for ${id}`)

	return { name, description: getMetaContent(html, "og:description") }
}

async function main(inputs: string[]): Promise<void> {
	if (inputs.length === 0) {
		throw new Error("Usage: add-chrome-extensions <extension name | Chrome Web Store URL | extension ID> [...]")
	}

	const sourceData = await readSourceData()
	const catalog: BrowserExtensions = {
		firefox: sourceData.extensions.firefox,
		chrome: sourceData.extensions.chrome,
	}
	let added = 0

	for (const input of inputs) {
		const id = await resolveExtensionId(input, catalog)
		const store = await fetchStoreMetadata(id)
		const name = getFirefoxPackageName(input, catalog) ?? makePackageName(store.name)
		const existing = catalog.chrome[name]
		if (existing?.id === id) {
			console.info(`[SKIP] ${name} is already in the Chrome extension catalog`)
			continue
		}
		if (existing) throw new Error(`${name} is already used by another Chrome extension (${existing.id})`)

		console.info(`[INFO] Fetching Chrome extension ${store.name} (${id})`)
		const release = await fetchChromeExtension(id)
		const meta: Record<string, string> = {
			name: store.name,
			homepage: `https://chromewebstore.google.com/detail/${id}`,
		}
		if (store.description) meta.description = store.description

		catalog.chrome[name] = { id, ...release, meta }
		console.info(`[SUCCESS] Added ${store.name} as ${name} v${release.version}`)
		added++
	}

	if (added > 0) {
		await writeSourceData(sourceData)
	}
	console.info(`[INFO] Added ${added} Chrome extension(s)`)
}

runScript(() => main(process.argv.slice(2)))
