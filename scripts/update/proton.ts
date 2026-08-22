import "dotenv/config"

import fs from "fs/promises"
import path from "path"

import { getGitLatestReleases } from "../helpers/git"
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

async function getDwProton() {
	console.log(`[INFO] Checking latest release for dw-proton...`)

	const proton = protons["dw-proton"]

	const data = await getGitLatestReleases({
		baseUrl: "https://dawn.wine/api/v1",
		author: "dawn-winery",
		repository: "dwproton",
	})

	if (!data) return null
	const newVersion = versionNormalization(data.tag_name.slice(9))
	const cachedVersion = proton.latest
	if (newVersion === cachedVersion) {
		console.info(`[SKIP] dw-proton is already up to date (${newVersion}).`)
		return null
	}

	console.info(`[UPDATE] New version found for dw-proton: ${cachedVersion} -> ${newVersion}`)
	const file = data.assets.find(({ name }) => name === `${data.name}-x86_64.tar.xz`)
	if (!file) {
		console.warn(`[WARN] Asset '${data.name}-x86_64.tar.xz' not found in release ${newVersion}.`)
		return null
	}

	console.info(`[INFO] Fetching zip hash from: ${file.download_url}`)
	const hash = await fetchZipHash(file.download_url)
	descriptions.push(`dw-proton ${newVersion} - Hash: ${hash}`)

	proton.latest = newVersion
	proton.releases[newVersion] = {
		url: file.download_url,
		hash,
	}

	protons["dw-proton"] = proton
}

async function writeCommit() {
	if (descriptions.length > 1) return null

	const commitFilePath = path.join(__dirname, "../../commit.txt")
	const preCommit = await fs.readFile(commitFilePath, "utf-8").catch(() => null)

	const write = preCommit ? `${preCommit}\n\n${descriptions.join("\n")}` : descriptions.join("\n")
	await fs.writeFile(commitFilePath, write, "utf-8")
}

;(async function main() {
	protons = JSON.parse(await fs.readFile(path.join(__dirname, "../../assets/proton.json"), "utf-8"))

	await getDwProton()

	await Promise.all([
		writeCommit(),
		fs.writeFile(path.join(__dirname, "../../assets/proton.json"), JSON.stringify(protons, null, 4), "utf-8"),
	])
})()
