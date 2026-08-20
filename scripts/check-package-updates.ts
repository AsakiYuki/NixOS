import "dotenv/config"

import path from "path"
import fs from "fs/promises"

import { getGithubRepoLatestRelease, LatestReleaseData } from "./helpers/github"
import { fetchZipHash } from "./helpers/nix"

let packages: any = {}

const descriptions: string[] = []

interface FetchLastPackageArgs {
	author: string
	repository: string
	package_name?: string
	pre_release?: boolean
	cache_version?: (cached: any) => string
	get_version?: (latestRelease: LatestReleaseData) => string
	new_version_found: (cached: any, latestRelease: LatestReleaseData, version: string) => any
	debug?: (cached: any, latest: LatestReleaseData) => void
}

async function fetchLastReleasePackage(options: FetchLastPackageArgs) {
	const {
		author,
		repository,
		package_name,
		pre_release = true,
		cache_version,
		get_version,
		new_version_found,
		debug,
	} = options

	const pkgName = package_name ?? repository
	const cached = packages[pkgName]

	console.log(`[INFO] Checking latest release for ${pkgName}...`)

	const latestRelease = await getGithubRepoLatestRelease(author, repository, pre_release)
	if (!latestRelease) {
		console.warn(`[WARN] Could not fetch latest release for ${pkgName}.`)
		return false
	}

	if (debug) debug(cached, latestRelease)

	const cacheVersion = cache_version?.(cached) ?? cached?.version
	const newVersion = get_version?.(latestRelease) ?? latestRelease.tag_name

	if (cacheVersion === newVersion) {
		console.info(`[SKIP] ${pkgName} is already up to date (v${newVersion}).`)
		return false
	}

	console.info(`[UPDATE] New version found for ${pkgName}: v${cacheVersion} -> v${newVersion}`)
	const ret = await new_version_found(cached, latestRelease, newVersion)
	if (ret) packages[pkgName] = ret

	console.info(`[SUCCESS] Updated ${pkgName} to v${newVersion}`)
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
				descriptions.push(`bun v${version} (Linux x64 Baseline) - Hash: ${hash}`)

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
				descriptions.push(`geode-cli v${version} (Linux x64) - Hash: ${hash}`)

				return { version, hash }
			},
		}),
		fetchLastReleasePackage({
			author: "PancakeTAS",
			repository: "lsfg-vk",
			cache_version: cached => `${cached.version}-dev${cached["dev-version"]}`,
			get_version: latest => latest.name.slice(8),
			new_version_found: async (cached, latest, version) => {
				const [package_version, dev_version] = version.split("-dev")
				const file = latest.assets[0]

				console.info(`[INFO] Fetching zip hash from: ${file.download_url}`)
				const hash = await fetchZipHash(file.download_url)
				descriptions.push(`lsfg-vk v${package_version}-dev${dev_version} (Linux x64) - Hash: ${hash}`)

				return { version: package_version, "dev-version": dev_version, hash }
			},
		}),
		fetchLastReleasePackage({
			author: "Xtr126",
			repository: "cage-xtmapper",
			cache_version: cached => cached.release,
			get_version: latest => latest.tag_name.slice(1),
			new_version_found: async (cached, latest, release) => {
				const file1 = latest.assets[0]
				const file2 = latest.assets[1]

				console.info(`[INFO] Fetching zip hash from: ${file1.download_url}, ${file2.download_url}`)
				const [hash1, hash2] = await Promise.all([
					fetchZipHash(file1.download_url, false),
					fetchZipHash(file2.download_url, false),
				])

				descriptions.push(`cage-xtmapper v${release} (Linux x64) - Hash 1: ${hash1}, Hash 2: ${hash2}`)

				return {
					release,
					"version-0.1.5": hash1,
					"version-0.2.0": hash2,
				}
			},
		}),
	])

	if (!status.some(v => v)) return

	await Promise.all([
		fs.writeFile(path.join(__dirname, "../assets/packages.json"), JSON.stringify(packages, null, 4)),
		fs.writeFile(path.join(__dirname, "../commit.txt"), descriptions.join("\n")),
	])
}

main()
