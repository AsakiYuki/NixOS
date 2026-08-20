const GITHUB_TOKEN = process.env.GITHUB_TOKEN
const auth: HeadersInit = GITHUB_TOKEN ? { Authorization: `Bearer ${GITHUB_TOKEN}` } : {}

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

export async function getGithubRepoLatestRelease(
	author: string,
	repository: string,
	preRelease: boolean = true,
): Promise<LatestReleaseData | null> {
	const response = await fetch(
		`https://api.github.com/repos/${author}/${repository}/releases${preRelease ? "" : "/latest"}`,
		{
			headers: {
				...auth,
			},
		},
	)

	if (response.status !== 200) return null
	const data = await response.json()
	const { name, tag_name, assets } = preRelease ? data[0] : data

	return {
		name,
		tag_name,
		assets: assets.map(function ({
			name,
			label,
			content_type,
			browser_download_url,
			digest,
		}: {
			name: string
			label: string
			content_type: string
			digest: string
			browser_download_url: string
		}) {
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
