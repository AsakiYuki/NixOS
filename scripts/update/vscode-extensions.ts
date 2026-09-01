import "dotenv/config"
import fs from "fs/promises"

import path from "path"

interface Extension {
	version: string
	hash: string
}

type VscodeExtensions = Record<string, Extension>

async function checkMarketplaceExtension(id: string, data: Extension): Promise<[string, Extension]> {
	return [id, data]
}

let vscodeExtensions: VscodeExtensions
;(async function main() {
	const filePath = path.join(__dirname, "../../assets/vscode.extensions.json")
	vscodeExtensions = <VscodeExtensions>JSON.parse(await fs.readFile(filePath, "utf-8"))

	vscodeExtensions = Object.fromEntries(
		await Promise.all(Object.entries(vscodeExtensions).map(args => checkMarketplaceExtension(...args))),
	)

	await fs.writeFile(filePath, JSON.stringify(vscodeExtensions, null, 4), "utf-8")
})()
