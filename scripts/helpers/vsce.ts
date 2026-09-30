import { UUID } from "crypto"
import { spawnStdout } from "../helpers/shell"

export interface Publisher {
	publisherId: UUID
	publisherName: string
	displayName: string
	flags: number
	domain: null | string
	isDomainVerified: boolean
}

export interface Property {
	key: string
	value: string
}

export interface Statistic {
	statisticName: string
	value: number
}

export interface Version {
	version: string
	flags: number
	lastUpdated: string
	properties: Property[]
}

export interface ExtensionInfo {
	publisher: Publisher
	extensionId: UUID
	extensionName: string
	displayName: string
	flags: number
	lastUpdated: string
	publishedDate: string
	releaseDate: string
	shortDescription: string
	versions: Version[]
	categories: string[]
	tags: string[]
	statistics: Statistic[]
	deploymentType: number
}

export class VSCE {
	private static async exec(...args: Array<string>) {
		return JSON.parse(await spawnStdout("vsce", [...args, "--json"]))
	}

	static standardizeProperties(properties: Property[]): Record<string, string> {
		return Object.fromEntries(properties.map(({ key, value }) => [key, value]))
	}

	static standardizeStatistic(statistics: Statistic[]): Record<string, number> {
		return Object.fromEntries(statistics.map(({ statisticName, value }) => [statisticName, value]))
	}

	static async show(extensionId: string): Promise<ExtensionInfo> {
		return await VSCE.exec("show", extensionId)
	}
}

VSCE.show("jbro.vscode-default-keybindings").then(v => console.log(JSON.stringify(v.extensionId)))
