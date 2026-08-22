import "dotenv/config"

import fs from "fs/promises"
import path from "path"

import { getGitLatestReleases, LatestReleaseData } from "../helpers/git"
import { getGithubRepoLatestRelease } from "../helpers/github"
import { fetchZipHash } from "../helpers/nix"

interface ProtonRelease {
	url: string
	hash: string
}

interface Proton {
	latest: string
	source_name: string
	override_name: string
	releases: Record<string, ProtonRelease>
}

interface FetchProtonReleaseArgs {
	key: string
	author: string
	repository: string
	baseUrl?: string
	preRelease?: boolean
	get_version: (latestRelease: LatestReleaseData) => string
	get_source_name: (latestRelease: LatestReleaseData) => string
	asset_extension?: string
}

let protons: Record<string, Proton> = {}
const descriptions: string[] = ["- proton update"]

function versionNormalization(version: string) {
	const charReplace: Record<string, string | void> = {
		".": "-",
		"-": "_",
	}
	return version.replace(/[.-]/g, char => {
		const replace = charReplace[char]
		return replace ? replace : char
	})
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
	const cachedVersion = proton.latest

	if (newVersion === cachedVersion) {
		console.info(`[SKIP] ${key} is already up to date (${newVersion}).`)
		return false
	}

	console.info(`[UPDATE] New version found for ${key}: ${cachedVersion} -> ${newVersion}`)

	const sourceName = get_source_name(latestRelease)
	const assetFileName = `${sourceName}.${asset_extension}`
	const file = latestRelease.assets.find(({ name }) => name === assetFileName)

	if (!file) {
		console.warn(`[WARN] Asset '${assetFileName}' not found in release ${latestRelease.tag_name}.`)
		return false
	}

	console.info(`[INFO] Fetching zip hash from: ${file.download_url}`)
	const hash = await fetchZipHash(file.download_url)
	descriptions.push(`${key} ${newVersion} - Hash: ${hash}`)

	proton.latest = newVersion
	proton.source_name = sourceName
	proton.releases[newVersion] = {
		url: file.download_url,
		hash,
	}

	protons[key] = proton
	return true
}

async function writeCommit() {
	if (descriptions.length <= 1) return

	const commitFilePath = path.join(__dirname, "../../commit.txt")
	const preCommit = await fs.readFile(commitFilePath, "utf-8").catch(() => null)

	const write = preCommit ? `${preCommit}\n\n${descriptions.join("\n")}` : descriptions.join("\n")
	await fs.writeFile(commitFilePath, write, "utf-8")
}

; (async function main() {
	protons = JSON.parse(await fs.readFile(path.join(__dirname, "../../assets/proton.json"), "utf-8"))

	const status = await Promise.all([
		fetchProtonRelease({
			key: "dw-proton",
			baseUrl: "https://dawn.wine/api/v1",
			author: "dawn-winery",
			repository: "dwproton",
			get_version: latest => versionNormalization(latest.tag_name.replace(/^dwproton-/, "")),
			get_source_name: latest => `${latest.name}-x86_64`,
			asset_extension: "tar.xz",
		}),
		fetchProtonRelease({
			key: "ge-proton",
			author: "GloriousEggroll",
			repository: "proton-ge-custom",
			get_version: latest => latest.tag_name.replace(/^GE-Proton/, ""),
			get_source_name: latest => `${latest.tag_name}-x86_64`,
			asset_extension: "tar.gz",
		}),
		fetchProtonRelease({
			key: "cachyos-proton",
			author: "CachyOS",
			repository: "proton-cachyos",
			get_version: latest => {
				const rawVersion = latest.tag_name.replace(/^cachyos-/, "").replace(/-slr$/, "")
				return versionNormalization(rawVersion)
			},
			get_source_name: latest => `proton-${latest.tag_name}-x86_64`,
			asset_extension: "tar.xz",
		}),
	])

	if (!status.some(v => v)) return

	await Promise.all([
		writeCommit(),
		fs.writeFile(path.join(__dirname, "../../assets/proton.json"), JSON.stringify(protons, null, 4), "utf-8"),
	])
})()
