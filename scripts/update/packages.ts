import "dotenv/config"
import * as cheerio from "cheerio"

import path from "path"
import fs from "fs/promises"

import { getGithubRepoLatestRelease } from "../helpers/github"
import { fetchUrlHash, fetchZipHash } from "../helpers/nix"
import { LatestReleaseData } from "../helpers/git"

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
	packages = JSON.parse(await fs.readFile(path.join(__dirname, "../../assets/packages.json"), "utf-8"))

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
		fetchLastReleasePackage({
			author: "hmlendea",
			repository: "gfn-electron",
			get_version: latest => latest.tag_name.slice(1),
			new_version_found: async (cached, latest, version) => {
				const file = latest.assets.find(({ name }) => name === `geforcenow-electron_${version}_linux.zip`)
				if (!file) {
					console.warn(`[WARN] Asset 'geforcenow-electron_${version}_linux.zip' not found in release v${version}.`)
					return false
				}

				console.info(`[INFO] Fetching zip hash from: ${file.download_url}`)
				const hash = await fetchZipHash(file.download_url)
				descriptions.push(`geforcenow-electron v${version} - Hash: ${hash}`)

				return { version, hash }
			},
		}),
		fetchLastReleasePackage({
			author: "OpenCloudGaming",
			repository: "OpenNOW",
			get_version: latest => latest.tag_name.slice(1),
			new_version_found: async (cached, latest, version) => {
				const file = latest.assets.find(({ name }) => name === `OpenNOW-v${version}-linux-amd64.deb`)

				if (!file) {
					console.warn(`[WARN] Asset 'OpenNOW-v${version}-linux-amd64.deb' not found in release v${version}.`)
					return false
				}

				console.info(`[INFO] Fetching url hash from: ${file.download_url}`)
				const hash = await fetchUrlHash(file.download_url)
				descriptions.push(`opennow- v${version} - Hash: ${hash}`)

				return { version, hash }
			},
		}),
		fetchLastReleasePackage({
			author: "zen-browser",
			repository: "desktop",
			package_name: "zen-browser",
			new_version_found: async (cached, latest, version) => {
				const files = latest.assets.filter(({ name }) => name.endsWith(".tar.xz"))

				const x86_64 = files.find(({ name }) => name.includes("x86_64"))
				const aarch64 = files.find(({ name }) => name.includes("aarch64"))

				if (!aarch64 || !x86_64) {
					console.warn(
						`[WARN] Asset 'zen.linux-x86_64.tar.xz' or 'zen.linux-aarch64.tar.xz' not found in release v${version}.`,
					)
					return false
				}

				console.info(
					`[INFO] Fetching url hash from:\n - amd64:${x86_64.download_url}\n - arm64: ${aarch64.download_url}`,
				)

				const [amd64, arm64] = await Promise.all([
					fetchZipHash(x86_64.download_url),
					fetchZipHash(aarch64.download_url),
				])

				descriptions.push(`zen-browser v${version} - Hash: amd64: ${amd64} - arm64: ${arm64}`)

				return { version, hash: { amd64, arm64 } }
			},
		}),
		fetchLastReleasePackage({
			author: "versenilvis",
			repository: "IRIS",
			package_name: "iris",
			get_version: ({ tag_name }) => tag_name.slice(1),
			new_version_found: async (cached, latest, version) => {
				const files = latest.assets.filter(({ name }) => name.endsWith(".tar.gz"))

				const x86_64 = files.find(({ name }) => name.includes("x_amd"))
				const aarch64 = files.find(({ name }) => name.includes("x_arm"))

				if (!aarch64 || !x86_64) {
					console.warn(
						`[WARN] Asset 'iris_linux_amd64.tar.gz' or 'iris_linux_arm64.tar.gz ' not found in release v${version}.`,
					)
					return false
				}

				console.info(`[INFO] Fetching url hash from:\n - amd64:${x86_64.download_url}\n - arm: ${aarch64.download_url}`)

				const [amd64, arm64] = await Promise.all([
					fetchZipHash(x86_64.download_url),
					fetchZipHash(aarch64.download_url),
				])

				descriptions.push(`iris v${version} - Hash: x86_64: ${amd64} - arm64: ${arm64}`)

				return { version, hash: { amd64, arm64 } }
			},
		}),
		(async function () {
			try {
				console.log(`[INFO] Checking latest release for cider-2...`)

				const compareVer = (a: string, b: string) =>
					a.localeCompare(b, undefined, { numeric: true, sensitivity: "base" })
				const getUrl = (file: string) => `https://repo.cider.sh/apt/pool/main/${file}`

				const html = await fetch("https://repo.cider.sh/apt/pool/main/").then(v => v.text())
				const $ = cheerio.load(html)

				const currentVersion = packages["cider-2"].version

				const latest = {
					x64: "",
					arm64: "",
				}

				$('a[href$=".deb"]').each((_, el) => {
					const href = $(el).attr("href")
					if (!href) return

					if (href.endsWith("-linux-x64.deb") && (!latest.x64 || compareVer(href, latest.x64) > 0)) latest.x64 = href
					else if (href.endsWith("-linux-arm64.deb") && (!latest.arm64 || compareVer(href, latest.arm64) > 0))
						latest.arm64 = href
				})

				const version = latest.x64.split("-")[1].slice(1)

				if (currentVersion === version) {
					console.info(`[SKIP] cider-2 is already up to date (v${version}).`)
					return false
				}

				console.info(`[UPDATE] New version found for cider-2: v${currentVersion} -> v${version}`)

				console.info(
					`[INFO] Fetching url hash from:\n - amd64: https://repo.cider.sh/apt/pool/main/${latest.x64}\n - arm64: https://repo.cider.sh/apt/pool/main/${latest.arm64}`,
				)

				const [arm64, amd64] = await Promise.all([fetchUrlHash(getUrl(latest.x64)), fetchUrlHash(getUrl(latest.arm64))])

				descriptions.push(`cider-2 v${version} - Hash: arm64: ${arm64} - arm64: ${amd64}`)

				packages["cider-2"] = {
					version,
					hash: { arm64, amd64 },
				}

				console.info(`[SUCCESS] Updated cider-2 to v${version}`)
				return true
			} catch (error) {
				console.warn(`[WARN] Could not fetch latest release for cider-2.`)
				return false
			}
		})(),
	])

	if (!status.some(v => v)) return

	await Promise.all([
		fs.writeFile(path.join(__dirname, "../../assets/packages.json"), JSON.stringify(packages, null, 4)),
		fs.writeFile(path.join(__dirname, "../../commit.txt"), descriptions.join("\n")),
	])
}

main()
