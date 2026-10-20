import fs from "node:fs/promises"
import path from "node:path"

const sourceDataPath = path.join(__dirname, "../../assets/sources.json")

export async function readSourceData<T extends Record<string, any> = Record<string, any>>(): Promise<T> {
	return JSON.parse(await fs.readFile(sourceDataPath, "utf-8")) as T
}

export async function writeSourceData(sourceData: Record<string, any>): Promise<void> {
	const temporaryPath = `${sourceDataPath}.tmp`
	await fs.writeFile(temporaryPath, `${JSON.stringify(sourceData, null, 4)}\n`, "utf-8")
	await fs.rename(temporaryPath, sourceDataPath)
}

export async function saveSourceUpdate(
	sourceData: Record<string, any>,
	changed: boolean,
): Promise<boolean> {
	if (!changed) return false

	await writeSourceData(sourceData)
	return true
}
