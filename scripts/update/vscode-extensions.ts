import "dotenv/config"
import fs from "fs/promises"

import { VSCE } from "../helpers/vsce"
import path from "path"

async function main() {
	const filepath = path.join(__dirname, "../../assets/vscode.extensions.json")
	const data: Record<string, Record<string, any>> = JSON.parse(await fs.readFile(filepath, "utf-8"))
	const commits: string[] = []

	await Promise.all(
		Object.entries(data).map(async ([author, extensions]) => {
			await Promise.all(
				Object.entries(extensions).map(async ([extension, info]) => {
					const id = `${author}.${extension}`
					const useVersionedVsixHash = id === "redhat.java"

					const extInfo = await VSCE.show(id)
					const currentVersion = extInfo.versions[0]
					if (
						info.src?.version === currentVersion.version &&
						(!useVersionedVsixHash || info.hashStrategy === "versioned-vsix")
					)
						return Promise.resolve(null)

					const properties = VSCE.standardizeProperties(currentVersion.properties)
					const hash = useVersionedVsixHash
						? await VSCE.hashVersionedVsix(id, currentVersion.version)
						: VSCE.toSriHash(properties["Microsoft.VisualStudio.Services.VsixSha256"])

					data[author][extension] = {
						...(useVersionedVsixHash ? { hashStrategy: "versioned-vsix" } : {}),
						src: {
							version: currentVersion.version,
							hash,
						},
						meta: {
							description: extInfo.shortDescription,
							homepage: properties["Microsoft.VisualStudio.Services.Links.Learn"],
							downloadPage: `https://marketplace.visualstudio.com/items?itemName=${id}`,
						},
					}

					console.info(`[SUCCESS] Updated ${id} to v${currentVersion.version}`)
					commits.push(`${id} ${currentVersion.version} - Hash: ${hash}`)
				}),
			)
		}),
	)

	await Promise.all([
		fs.writeFile(filepath, JSON.stringify(data, null, 4), "utf-8"),
		fs.writeFile(path.join(__dirname, "../../vscode-extensions-commit.txt"), commits.join("\n")),
	])
}

main()
