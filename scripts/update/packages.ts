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

	const ret = await new_version_found(cached, latestRelease, newVersion)
	if (!ret) {
		console.warn(`[WARN] Failed to process update for ${pkgName}.`)
		return false
	}

	packages[pkgName] = ret
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
				const assets = {
					"x86_64-linux": latest.assets.find(({ name }) => name === "bun-linux-x64-baseline.zip"),
					"aarch64-linux": latest.assets.find(({ name }) => name === "bun-linux-aarch64.zip"),
				}
				if (!assets["x86_64-linux"] || !assets["aarch64-linux"]) {
					console.warn(`[WARN] Bun x64 baseline or Linux aarch64 asset not found in release v${version}.`)
					return false
				}

				const [x64Hash, arm64Hash] = await Promise.all([
					fetchZipHash(assets["x86_64-linux"].download_url),
					fetchZipHash(assets["aarch64-linux"].download_url),
				])
				descriptions.push(`bun v${version} - Hash: x86_64: ${x64Hash} - aarch64: ${arm64Hash}`)

				return {
					version,
					source: {
						"x86_64-linux": { url: assets["x86_64-linux"].download_url, hash: x64Hash },
						"aarch64-linux": { url: assets["aarch64-linux"].download_url, hash: arm64Hash },
					},
				}
			},
		}),
		fetchLastReleasePackage({
			author: "geode-sdk",
			repository: "cli",
			package_name: "geode-cli",
			get_version: latest => latest.tag_name.slice(1),
			new_version_found: async (cached, latest, version) => {
				const assets = {
					"x86_64-linux": latest.assets.find(({ name }) => name === `geode-cli-v${version}-linux.zip`),
					"aarch64-linux": latest.assets.find(({ name }) => name === `geode-cli-v${version}-linux-arm.zip`),
					"x86_64-darwin": latest.assets.find(({ name }) => name === `geode-cli-v${version}-mac.zip`),
				}
				if (!Object.values(assets).some(Boolean)) {
					console.warn(`[WARN] No supported platform asset found for geode-cli v${version}.`)
					return false
				}

				const source: Record<string, { url: string; hash: string }> = {}
				for (const [system, file] of Object.entries(assets)) {
					if (!file) continue
					console.info(`[INFO] Fetching archive hash from: ${file.download_url}`)
					const hash = await fetchUrlHash(file.download_url)
					descriptions.push(`geode-cli v${version} (${system}) - Hash: ${hash}`)
					source[system] = { url: file.download_url, hash }
				}

				return { version, source }
			},
		}),
		(async function () {
			try {
				console.log(`[INFO] Checking latest release for lsfg-vk...`)

				const html = await fetch("https://builds.lsfg-vk.dev/").then(v => v.text())
				const $ = cheerio.load(html)

				const cached = packages["lsfg-vk"]
				const currentVersion = cached?.version

				let href = ""
				$("a").each((_, el) => {
					const text = $(el).text()
					if (!href && (text.includes("Latest git version") || text.includes("Latest release"))) {
						href = $(el).attr("href") || ""
					}
				})

				const match = href.match(/^lsfg-vk-(.+)\.tar\.xz$/)
				if (!match) {
					console.warn(`[WARN] Could not find latest git build for lsfg-vk.`)
					return false
				}

				const version = match[1]

				if (currentVersion === version) {
					console.info(`[SKIP] lsfg-vk is already up to date (v${version}).`)
					return false
				}

				console.info(`[UPDATE] New version found for lsfg-vk: v${currentVersion} -> v${version}`)

				const downloadUrl = `https://builds.lsfg-vk.dev/${href}`
				console.info(`[INFO] Fetching zip hash from: ${downloadUrl}`)

				const hash = await fetchZipHash(downloadUrl)

				descriptions.push(`lsfg-vk v${version} (Linux x64) - Hash: ${hash}`)

				packages["lsfg-vk"] = {
					version,
					source: { "x86_64-linux": { url: downloadUrl, hash } },
				}

				console.info(`[SUCCESS] Updated lsfg-vk to v${version}`)
				return true
			} catch (error) {
				console.warn(`[WARN] Could not fetch latest release for lsfg-vk: ${error}`)
				return false
			}
		})(),
		fetchLastReleasePackage({
			author: "Xtr126",
			repository: "cage-xtmapper",
			cache_version: cached => cached.release,
			get_version: latest => latest.tag_name.slice(1),
			new_version_found: async (cached, latest, release) => {
				const findTarForVersion = (version: string) =>
					latest.assets.find(({ name }) => name.toLowerCase().endsWith(".tar") && name.includes(version))
				const file1 = findTarForVersion("0.1.5")
				const file2 = findTarForVersion("0.2.0")

				if (!file1 || !file2) {
					console.warn(
						`[WARN] Expected cage-xtmapper v0.1.5 and v0.2.0 tar assets not found in release v${release}.`,
					)
					return false
				}

				console.info(`[INFO] Fetching zip hash from: ${file1.download_url}, ${file2.download_url}`)
				const [hash1, hash2] = await Promise.all([
					fetchZipHash(file1.download_url, false),
					fetchZipHash(file2.download_url, false),
				])

				descriptions.push(`cage-xtmapper v${release} (Linux x64) - Hash 1: ${hash1}, Hash 2: ${hash2}`)

				return {
					release,
					versions: {
						"0.1.5": { "x86_64-linux": { url: file1.download_url, hash: hash1 } },
						"0.2.0": { "x86_64-linux": { url: file2.download_url, hash: hash2 } },
					},
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

				return { version, source: { "x86_64-linux": { url: file.download_url, hash } } }
			},
		}),
		fetchLastReleasePackage({
			author: "OpenCloudGaming",
			repository: "OpenNOW",
			package_name: "opennow",
			pre_release: false,
			get_version: latest => latest.tag_name.slice(1),
			new_version_found: async (cached, latest, version) => {
				const linuxDebs = latest.assets.filter(({ name }) => {
					const normalizedName = name.toLowerCase()
					return normalizedName.endsWith(".deb") && normalizedName.includes("linux") && name.includes(version)
				})
				const assets = {
					"x86_64-linux": linuxDebs.find(({ name }) => /(?:x64|amd64)/i.test(name)),
					"aarch64-linux": linuxDebs.find(({ name }) => /(?:arm64|aarch64)/i.test(name)),
				}

				if (!assets["x86_64-linux"] || !assets["aarch64-linux"]) {
					console.warn(`[WARN] OpenNOW x86_64 or aarch64 Linux .deb asset not found in release v${version}.`)
					return false
				}

				const [x64Hash, arm64Hash] = await Promise.all([
					fetchUrlHash(assets["x86_64-linux"].download_url),
					fetchUrlHash(assets["aarch64-linux"].download_url),
				])
				descriptions.push(`opennow v${version} - Hash: x86_64: ${x64Hash} - aarch64: ${arm64Hash}`)

				return {
					version,
					source: {
						"x86_64-linux": { url: assets["x86_64-linux"].download_url, hash: x64Hash },
						"aarch64-linux": { url: assets["aarch64-linux"].download_url, hash: arm64Hash },
					},
				}
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

				console.info(
					`[INFO] Fetching url hash from:\n - amd64:${x86_64.download_url}\n - arm64: ${aarch64.download_url}`,
				)

				const [amd64, arm64] = await Promise.all([
					fetchZipHash(x86_64.download_url),
					fetchZipHash(aarch64.download_url),
				])

				descriptions.push(`iris v${version} - Hash: x86_64: ${amd64} - arm64: ${arm64}`)

				return {
					version,
					source: {
						"x86_64-linux": { url: x86_64.download_url, hash: amd64 },
						"aarch64-linux": { url: aarch64.download_url, hash: arm64 },
					},
				}
			},
		}),
		fetchLastReleasePackage({
			author: "Wyze3306",
			repository: "BedrockOnLinux",
			package_name: "bedrock-on-linux",
			pre_release: false,
			get_version: ({ tag_name }) => tag_name.slice(1),
			new_version_found: async (cached, latest, version) => {
				const file = latest.assets.find(({ name }) => name.endsWith(".rpm"))
				if (!file) return false

				console.info(`[INFO] Fetching zip hash from: ${file.download_url}`)
				const hash = await fetchUrlHash(file.download_url)
				descriptions.push(`bedrock-on-linux v${version} - Hash: ${hash}`)

				return { version, source: { "x86_64-linux": { url: file.download_url, hash } } }
			},
		}),
		fetchLastReleasePackage({
			author: "Ebullioscopic",
			repository: "Atoll",
			package_name: "atoll",
			pre_release: false,
			get_version: latest => latest.tag_name.replace(/^v/, ""),
			new_version_found: async (cached, latest, version) => {
				const file = latest.assets.find(({ name }) => name === `Atoll-${version}.dmg`)
				if (!file) {
					console.warn(`[WARN] Asset 'Atoll-${version}.dmg' not found in release v${version}.`)
					return false
				}

				console.info(`[INFO] Fetching url hash from: ${file.download_url}`)
				const hash = await fetchUrlHash(file.download_url)
				descriptions.push(`atoll v${version} - Hash: ${hash}`)

				return { version, source: { "universal-darwin": { url: file.download_url, hash } } }
			},
		}),
		fetchLastReleasePackage({
			author: "storytold",
			repository: "photocraft",
			package_name: "photocraft",
			pre_release: false,
			get_version: latest => latest.tag_name.replace(/^v/, ""),
			new_version_found: async (cached, latest, version) => {
				const files = latest.assets.filter(({ name }) => name.endsWith(".tar.gz"))

				const x86_64 = files.find(({ name }) => name.includes("linux-x86_64"))
				const aarch64 = files.find(({ name }) => name.includes("linux-aarch64"))

				if (!x86_64 || !aarch64) {
					console.warn(
						`[WARN] Asset 'photocraft-${version}-linux-x86_64.tar.gz' or 'linux-aarch64' not found in release v${version}.`,
					)
					return false
				}

				console.info(
					`[INFO] Fetching zip hash from:\n - amd64: ${x86_64.download_url}\n - arm64: ${aarch64.download_url}`,
				)

				const [amd64, arm64] = await Promise.all([
					fetchZipHash(x86_64.download_url),
					fetchZipHash(aarch64.download_url),
				])

				descriptions.push(`photocraft v${version} - Hash: x86_64: ${amd64} - aarch64: ${arm64}`)

				return {
					version,
					source: {
						"x86_64-linux": { url: x86_64.download_url, hash: amd64 },
						"aarch64-linux": { url: aarch64.download_url, hash: arm64 },
					},
				}
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

				const cached = packages["cider-2"]
				const currentVersion = cached?.version

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

				const [amd64, arm64] = await Promise.all([fetchUrlHash(getUrl(latest.x64)), fetchUrlHash(getUrl(latest.arm64))])

				descriptions.push(`cider-2 v${version} - Hash: x86_64: ${amd64} - aarch64: ${arm64}`)

				packages["cider-2"] = {
					...cached,
					version,
					source: {
						...cached?.source,
						"x86_64-linux": { url: getUrl(latest.x64), hash: amd64 },
						"aarch64-linux": { url: getUrl(latest.arm64), hash: arm64 },
					},
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
		fs.writeFile(path.join(__dirname, "../../packages-commit.txt"), descriptions.join("\n")),
	])
}

main()
