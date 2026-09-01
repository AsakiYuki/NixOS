import "dotenv/config"
import fs from "fs/promises"

import path from "path"
import { spawnStdout } from "../helpers/shell"
import { UUID } from "crypto"
import { info } from "console"

interface Extension {
	version: string
	hash: string
}

type VscodeExtensions = Record<string, Extension>

interface ExtensionPublisher {
	publisherId: UUID
	publisherName: string
	displayName: string
	flags: number
	domain: null | string
	isDomainVerified: boolean
}

interface ExtensionVersionProperty {
	key: string
	value: string
}

interface ExtensionVersion {
	version: string
	flags: number
	lastUpdated: string
	properties: Array<ExtensionVersionProperty>
}

interface ExtensionStatistic {
	statisticName: string
	value: number
}

interface ExtensionInfos {
	publisher: ExtensionPublisher
	extensionId: UUID
	extensionName: string
	displayName: string
	flags: number
	lastUpdated: string
	publishedDate: string
	releaseDate: string
	shortDescription: string
	versions: Array<ExtensionVersion>
	categories: Array<string>
	tags: Array<string>
	statistics: Array<ExtensionStatistic>
	deploymentType: number
}

const descriptions: string[] = []

async function getExtInfos(extId: string): Promise<ExtensionInfos> {
	return JSON.parse(await spawnStdout("vsce", ["show", extId, "--json"]))
}

async function checkMarketplaceExtension(extId: string, data: Extension): Promise<[string, Extension]> {
	const infos = await getExtInfos(extId)

	console.log(`[INFO] Checking update for ${extId}...`)

	const currentVersion = data.version
	const newVersion = infos.versions[0].version

	if (currentVersion === newVersion) {
		console.info(`[SKIP] ${extId} is already up to date (${currentVersion}).`)
		return [extId, data]
	}

	console.info(`[UPDATE] New version found for ${extId}: ${currentVersion} -> ${newVersion}`)

	const vsixSha256 = infos.versions[0].properties.find(
		({ key }) => key === "Microsoft.VisualStudio.Services.VsixSha256",
	)

	const convertedHash = await spawnStdout("nix", [
		"--extra-experimental-features",
		"nix-command",
		"hash",
		"convert",
		"--to",
		"sri",
		"--hash-algo",
		"sha256",
		vsixSha256?.value!,
	])

	descriptions.push(`${extId} ${newVersion} - Hash: ${convertedHash}`)
	console.info(`[SUCCESS] Updated ${extId} to v${newVersion}`)

	return [extId, { version: newVersion, hash: convertedHash }]
}

let vscodeExtensions: VscodeExtensions
;(async function main() {
	const filePath = path.join(__dirname, "../../assets/vscode.extensions.json")
	vscodeExtensions = <VscodeExtensions>JSON.parse(await fs.readFile(filePath, "utf-8"))

	vscodeExtensions = Object.fromEntries(
		await Promise.all(Object.entries(vscodeExtensions).map(args => checkMarketplaceExtension(...args))),
	)

	if (descriptions.length === 0) return

	await Promise.all([
		fs.writeFile(filePath, JSON.stringify(vscodeExtensions, null, 4), "utf-8"),
		fs.writeFile(path.join(__dirname, "../../commit.txt"), descriptions.join("\n")),
	])
})()
