import path from "path"
import fs from "fs/promises"
import { VSCE } from "../helpers/vsce"

async function main(...args: string[]) {
	const filepath = path.join(__dirname, "../../assets/vscode.extensions.json")
	const extensions: Record<string, Record<string, any>> = JSON.parse(await fs.readFile(filepath, "utf-8"))

	await Promise.all(
		args
			.map(extension => {
				const getExtNameRegex = /(?<=itemName\=)(\w|-)+.(\w|-)+/
				const isExtName = /^(\w|-)+.(\w|-)+$/
				if (getExtNameRegex.test(extension)) extension = extension.match(getExtNameRegex)?.[0]!
				if (!isExtName.test(extension)) return null
				return extension.split(".")
			})
			.filter(ext => ext !== null && !extensions[ext[0]]?.[ext[1]])
			.map(async ext => {
				const id = ext?.join(".")!

				const extInfo = await VSCE.show(id)
				const currentVersion = extInfo.versions[0]

				const properties = VSCE.standardizeProperties(currentVersion.properties)
				const hash = VSCE.toSriHash(properties["Microsoft.VisualStudio.Services.VsixSha256"])

				if (!extensions[ext?.[0]!]) extensions[ext?.[0]!] = {}

				extensions[ext?.[0]!][ext?.[1]!] = {
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

				console.log(`[INFO] Added vscode extension: ${id} - ${currentVersion.version} - ${hash}`)
			}),
	)

	await fs.writeFile(filepath, JSON.stringify(extensions, null, 4), "utf-8")
}

main(...process.argv.slice(2))
