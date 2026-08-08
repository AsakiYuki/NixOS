import path from "path"
import fs from "fs/promises"

import { getGithubRepoLatestRelease, LatestReleaseData } from "./helpers/github"
import { fetchZipHash } from "./helpers/nix"

let packages: any = {}

interface FetchLastPackageArgs {
	author: string
	repository: string
	package_name: string
	cache_version?: (cached: any) => string
	get_version?: (latestRelease: LatestReleaseData) => string
	new_version_found: (cached: any, latestRelease: LatestReleaseData, version: string) => any
	debug?: (cached: any, latest: LatestReleaseData) => void
}

async function fetchLastReleasePackage(options: FetchLastPackageArgs) {
	const { author, repository, package_name, cache_version, get_version, new_version_found, debug } = options

	const cached = packages[package_name]

	console.log(`[INFO] Checking latest release for ${package_name}...`)

	const latestRelease = await getGithubRepoLatestRelease(author, repository)
	if (!latestRelease) {
		console.warn(`[WARN] Could not fetch latest release for ${package_name}.`)
		return false
	}

	if (debug) debug(cached, latestRelease)

	const cacheVersion = cache_version?.(cached) ?? cached?.version
	const newVersion = get_version?.(latestRelease) ?? latestRelease.tag_name

	if (cacheVersion === newVersion) {
		console.info(`[SKIP] ${package_name} is already up to date (v${newVersion}).`)
		return false
	}

	console.info(`[UPDATE] New version found for ${package_name}: v${cacheVersion} -> v${newVersion}`)
	const ret = await new_version_found(cached, latestRelease, newVersion)
	if (ret) packages[package_name] = ret

	console.info(`[SUCCESS] Updated ${package_name} to v${newVersion}`)
	return true
}

async function main() {
	packages = JSON.parse(await fs.readFile(path.join(__dirname, "../assets/packages.json"), "utf-8"))

	const status = await Promise.all([
		fetchLastReleasePackage({
			author: "oven-sh",
			repository: "bun",
			package_name: "bun-baseline",
			get_version: latest => latest.tag_name.split("v")[1],
			new_version_found: async (cached, latest, version) => {
				const file = latest.assets.find(({ name }) => name === "bun-linux-x64-baseline.zip")
				if (!file) {
					console.warn(`[WARN] Asset 'bun-linux-x64-baseline.zip' not found in release v${version}.`)
					return false
				}

				console.info(`[INFO] Fetching zip hash from: ${file.download_url}`)
				const hash = await fetchZipHash(file.download_url)

				return { version, hash }
			},
		}),
		fetchLastReleasePackage({
			author: "geode-sdk",
			repository: "cli",
			package_name: "geode-cli",
			get_version: latest => latest.tag_name.slice(1),
			new_version_found: async (cached, latest, version) => {
				const file = latest.assets.find(({ name }) => name === `geode-cli-v${version}-linux.zip`)
				if (!file) {
					console.warn(`[WARN] Asset 'geode-cli-v${version}-linux.zip' not found in release v${version}.`)
					return false
				}

				console.info(`[INFO] Fetching zip hash from: ${file.download_url}`)
				const hash = await fetchZipHash(file.download_url)

				return { version, hash }
			},
		}),
	])

	if (!status.some(v => v)) return

	await fs.writeFile(path.join(__dirname, "../assets/packages.json"), JSON.stringify(packages, null, 4))
	// if (!test) return
	// console.log(test)
	// fetchZipHash(test.assets[0].download_url).then(console.log)
}

main()
