import { getGitLatestReleases } from "./git"

const GH_TOKEN = process.env.GH_TOKEN
const auth: HeadersInit = GH_TOKEN ? { Authorization: `Bearer ${GH_TOKEN}` } : {}

export async function getGithubRepoLatestRelease(author: string, repository: string, preRelease: boolean = true) {
	return await getGitLatestReleases({
		baseUrl: "https://api.github.com",
		author,
		repository,
		preRelease,
		headers: auth,
	})
}
