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
