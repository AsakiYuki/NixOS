export type LocalizedString = Record<string, string>
export type LocalizedNullableString = Record<string, string | null>

export interface AmoAuthor {
	id: number
	name: string
	url: string
	username: string
	picture_url: string | null
}

export interface AmoCompatibility {
	min: string
	max: string
}

export interface AmoVersionFile {
	id: number
	created: string
	hash: string
	is_mozilla_signed_extension: boolean
	size: number
	status: "public" | "unlisted" | string
	url: string
	permissions: string[]
	optional_permissions: string[]
	host_permissions: string[]
	data_collection_permissions: string[]
	optional_data_collection_permissions: string[]
}

export interface AmoLicense {
	id: number
	is_custom: boolean
	name: LocalizedString
	slug: string
	url: string
}

export interface AmoVersion {
	id: number
	compatibility: {
		firefox?: AmoCompatibility
		android?: AmoCompatibility
		[key: string]: AmoCompatibility | undefined
	}
	edit_url: string
	file: AmoVersionFile
	is_strict_compatibility_enabled: boolean
	license: AmoLicense
	release_notes: LocalizedNullableString | null
	reviewed: string
	version: string
}

export interface AmoHomepage {
	url: LocalizedString
	outgoing: LocalizedNullableString
}

export interface AmoPreview {
	id: number
	caption: LocalizedString
	image_size: [number, number]
	image_url: string
	position: number
	thumbnail_size: [number, number]
	thumbnail_url: string
}

export interface AmoPromoted {
	apps: ("firefox" | "android" | string)[]
	category: "recommended" | "line" | "spotlight" | string
}

export interface AmoRatings {
	average: number
	bayesian_average: number
	count: number
	text_count: number
}

export interface AmoSupportUrl {
	url: LocalizedString
	outgoing: LocalizedNullableString
}

export interface AmoAddonResponse {
	id: number
	authors: AmoAuthor[]
	average_daily_users: number
	categories: string[]
	contributions_url: string
	created: string
	current_version: AmoVersion
	default_locale: string
	description: LocalizedString
	developer_comments: LocalizedNullableString | null
	edit_url: string
	guid: string
	has_eula: boolean
	has_privacy_policy: boolean
	homepage: AmoHomepage
	icon_url: string
	icons: Record<string, string>
	is_disabled: boolean
	is_experimental: boolean
	is_noindexed: boolean
	last_updated: string
	name: LocalizedString
	previews: AmoPreview[]
	promoted: AmoPromoted[]
	ratings: AmoRatings
	ratings_url: string
	requires_payment: boolean
	review_url: string
	slug: string
	status: "public" | string
	summary: LocalizedString
	support_email: LocalizedNullableString | null
	support_url: AmoSupportUrl
	tags: string[]
	type: "extension" | "theme" | string
	url: string
	versions_url: string
	weekly_downloads: number
}

export interface ExtensionSource {
	url: string
	hash: string
}

export interface FirefoxAddon {
	version: string
	id: string
	src: ExtensionSource
	meta?: Record<string, string>
}

export interface ChromeExtension {
	version: string
	id: string
	src: ExtensionSource
	meta?: Record<string, string>
	managedSettings: Record<string, unknown>
}

export interface BrowserExtensions {
	firefox: Record<string, FirefoxAddon>
	chrome: Record<string, ChromeExtension>
}

export function getLocalized(record?: Record<string, string | null>, defaultLocale?: string): string {
	if (!record) return ""
	return record["en-US"] || (defaultLocale && record[defaultLocale]) || Object.values(record)[0] || ""
}

export async function fetchFirefoxAddon(slugOrGuid: string): Promise<AmoAddonResponse> {
	const url = `https://addons.mozilla.org/api/v5/addons/addon/${encodeURIComponent(slugOrGuid)}/`

	const res = await fetch(url, {
		headers: {
			"User-Agent": "Mozilla/5.0 (compatible; BunAddonFetcher/1.0)",
		},
	})

	if (!res.ok) {
		throw new Error(`AMO Error [${res.status}]: ${res.statusText} (${slugOrGuid})`)
	}

	return (await res.json()) as AmoAddonResponse
}

function parseChromeUpdateAttributes(value: string): Record<string, string> {
	return Object.fromEntries(
		Array.from(value.matchAll(/([\w-]+)="([^"]*)"/g), ([, key, item]) => [key, item]),
	)
}

function toSriHash(hex: string): string {
	if (!/^[\da-f]{64}$/i.test(hex)) throw new Error(`Invalid SHA-256 from Chrome update manifest: ${hex}`)
	return `sha256-${Buffer.from(hex, "hex").toString("base64")}`
}

export async function fetchChromeExtension(id: string): Promise<Pick<ChromeExtension, "version" | "src">> {
	const url = new URL("https://clients2.google.com/service/update2/crx")
	url.searchParams.set("response", "updatecheck")
	url.searchParams.set("prodversion", "155.0.0.0")
	url.searchParams.set("acceptformat", "crx3")
	url.searchParams.set("x", `id=${id}&installsource=ondemand&uc`)

	const response = await fetch(url, {
		headers: { "User-Agent": "Mozilla/5.0 (compatible; NixBrowserExtensionUpdater/1.0)" },
		signal: AbortSignal.timeout(60_000),
	})
	if (!response.ok) throw new Error(`Chrome update service returned HTTP ${response.status} for ${id}`)

	const xml = await response.text()
	const match = xml.match(/<updatecheck\b([^>]*)\/?\s*>/)
	if (!match) throw new Error(`Chrome update service returned no updatecheck for ${id}`)

	const attributes = parseChromeUpdateAttributes(match[1])
	if (attributes.status !== "ok") {
		throw new Error(`No compatible Chrome update found for ${id} (status: ${attributes.status ?? "missing"})`)
	}
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
