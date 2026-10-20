import "dotenv/config"

import { getGitLatestReleases, LatestReleaseData } from "../helpers/git"
import { getGithubRepoLatestRelease } from "../helpers/github"
import { fetchUrlHash } from "../helpers/nix"
import { runScript } from "../helpers/cli"
import { readSourceData, saveSourceUpdate } from "../helpers/source-data"

type ProtonSystem = "x86_64-linux" | "aarch64-linux"
type ProtonArchitecture = "x86_64" | "aarch64"

interface ProtonSource {
	url: string
	hash: string
}

interface Proton {
	latest: string
	source_name: Partial<Record<ProtonSystem, string>>
	override_name: string
	releases: Record<string, Partial<Record<ProtonSystem, ProtonSource>>>
}

interface FetchProtonReleaseArgs {
	key: string
	author: string
	repository: string
	baseUrl?: string
	preRelease?: boolean
	get_version: (latestRelease: LatestReleaseData) => string
	get_source_name: (latestRelease: LatestReleaseData, architecture: ProtonArchitecture) => string | undefined
	asset_extension?: string
}

const systems: Record<ProtonArchitecture, ProtonSystem> = {
	x86_64: "x86_64-linux",
	aarch64: "aarch64-linux",
}

let protons: Record<string, Proton> = {}

function versionNormalization(version: string) {
	const charReplace: Record<string, string | void> = {
		".": "-",
		"-": "_",
	}
	return version.replace(/[.-]/g, char => charReplace[char] ?? char)
}

async function fetchProtonRelease(options: FetchProtonReleaseArgs) {
	const {
		key,
		author,
		repository,
		baseUrl,
		preRelease = true,
		get_version,
		get_source_name,
		asset_extension = "tar.xz",
	} = options

	const proton = protons[key]
	if (!proton) {
		console.warn(`[WARN] Key '${key}' not found in protons configuration.`)
		return false
	}

	console.log(`[INFO] Checking latest release for ${key}...`)
	const latestRelease = baseUrl
		? await getGitLatestReleases({ baseUrl, author, repository, preRelease })
		: await getGithubRepoLatestRelease(author, repository, preRelease)

	if (!latestRelease) {
		console.warn(`[WARN] Could not fetch latest release for ${key}.`)
		return false
	}

	const newVersion = get_version(latestRelease)
	const versionChanged = newVersion !== proton.latest
	if (versionChanged) {
		console.info(`[UPDATE] New version found for ${key}: ${proton.latest} -> ${newVersion}`)
	}

	const release = proton.releases[newVersion] ?? {}
	let changed = versionChanged

	for (const architecture of Object.keys(systems) as ProtonArchitecture[]) {
		const sourceName = get_source_name(latestRelease, architecture)
		if (!sourceName) continue

		const system = systems[architecture]
		const assetName = `${sourceName}.${asset_extension}`
		const asset = latestRelease.assets.find(candidate => candidate.name === assetName)
		if (!asset) {
			console.info(`[INFO] ${key} ${newVersion} has no ${system} asset (${assetName}).`)
			continue
		}

		if (release[system]?.url === asset.download_url && release[system]?.hash) continue

		console.info(`[INFO] Fetching ${system} archive hash from: ${asset.download_url}`)
		const source = { url: asset.download_url, hash: await fetchUrlHash(asset.download_url) }
		release[system] = source
		proton.source_name[system] = sourceName
		changed = true
	}

	if (Object.keys(release).length === 0) {
		console.warn(`[WARN] No supported architecture assets found for ${key} ${newVersion}.`)
		return false
	}

	if (!changed) {
		console.info(`[SKIP] ${key} is already up to date (${newVersion}) and its available assets are recorded.`)
		return false
	}

	proton.latest = newVersion
	proton.releases[newVersion] = release
	protons[key] = proton
	return true
}

async function main() {
	const sourceData = await readSourceData()
	protons = sourceData.packages.wine

	const status = await Promise.all([
		fetchProtonRelease({
			key: "dw-proton",
			baseUrl: "https://dawn.wine/api/v1",
			author: "dawn-winery",
			repository: "dwproton",
			get_version: latest => versionNormalization(latest.tag_name.replace(/^dwproton-/, "")),
			get_source_name: (latest, arch) => `${latest.name}-${arch}`,
		}),
		fetchProtonRelease({
			key: "ge-proton",
			author: "GloriousEggroll",
			repository: "proton-ge-custom",
			get_version: latest => latest.tag_name.replace(/^GE-Proton/, ""),
			get_source_name: (latest, arch) => `${latest.tag_name}-${arch}`,
			asset_extension: "tar.gz",
		}),
		fetchProtonRelease({
			key: "cachyos-proton",
			author: "CachyOS",
			repository: "proton-cachyos",
			get_version: latest => versionNormalization(latest.tag_name.replace(/^cachyos-/, "").replace(/-slr$/, "")),
			get_source_name: (latest, arch) => `proton-${latest.tag_name}-${arch === "aarch64" ? "arm64" : arch}`,
		}),
		fetchProtonRelease({
			key: "cachyos-proton-v3",
			author: "CachyOS",
			repository: "proton-cachyos",
			get_version: latest => versionNormalization(latest.tag_name.replace(/^cachyos-/, "").replace(/-slr$/, "")),
			get_source_name: (latest, arch) => arch === "x86_64" ? `proton-${latest.tag_name}-x86_64_v3` : undefined,
		}),
		fetchProtonRelease({
			key: "wineland-proton",
			author: "nanomatters",
			repository: "proton-cachyos",
			get_version: latest => versionNormalization(latest.tag_name.replace(/^wineland-/, "").replace(/-slr$/, "")),
			get_source_name: (latest, arch) => `proton-${latest.tag_name}-${arch === "aarch64" ? "arm64" : arch}`,
		}),
		fetchProtonRelease({
			key: "wineland-proton-v3",
			author: "nanomatters",
			repository: "proton-cachyos",
			get_version: latest => versionNormalization(latest.tag_name.replace(/^wineland-/, "").replace(/-slr$/, "")),
			get_source_name: (latest, arch) => arch === "x86_64" ? `proton-${latest.tag_name}-x86_64_v3` : undefined,
		}),
	])

	await saveSourceUpdate(sourceData, status.some(Boolean))
}

runScript(main)
