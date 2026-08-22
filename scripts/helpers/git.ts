export interface Asset {
	name: string
	label: string
	download_url: string
	content_type: string
	digest: string
}

export interface LatestReleaseData {
	name: string
	tag_name: string
	assets: Asset[]
}

export interface GetLatestParameters {
	baseUrl: string
	author: string
	repository: string
	preRelease?: boolean
	headers?: HeadersInit
}

export async function getGitLatestReleases({
	baseUrl,
	author,
	repository,
	preRelease = true,
	headers = {},
}: GetLatestParameters): Promise<LatestReleaseData | null> {
	const latest = preRelease ? "" : "/latest"
	const res = await fetch(`${baseUrl}/repos/${author}/${repository}/releases${latest}`, { headers })

	if (res.status !== 200) return null
	const data = await res.json()
	const { name, tag_name, assets } = preRelease ? data[0] : data

	interface AssetParameters {
		name: string
		label: string
		content_type: string
		digest: string
		browser_download_url: string
	}

	return {
		name,
		tag_name,
		assets: assets.map(({ name, label, content_type, browser_download_url, digest }: AssetParameters) => {
			return {
				name,
				label,
				content_type,
				download_url: browser_download_url,
				digest,
			}
		}),
	}
}
