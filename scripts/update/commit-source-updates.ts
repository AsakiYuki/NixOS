import { execFileSync, spawnSync } from "node:child_process"
import { isDeepStrictEqual } from "node:util"
import { runScript } from "../helpers/cli"

type JsonObject = Record<string, any>

function changedKeys(before: JsonObject = {}, after: JsonObject = {}): string[] {
	return [...new Set([...Object.keys(before), ...Object.keys(after)])]
		.filter(key => !isDeepStrictEqual(before[key], after[key]))
		.sort()
}

function changedNestedKeys(before: JsonObject = {}, after: JsonObject = {}): string[] {
	return [...new Set([...Object.keys(before), ...Object.keys(after)])]
		.flatMap(group => changedKeys(before[group], after[group]).map(name => `${group}.${name}`))
		.sort()
}

function extensionChanges(before: JsonObject, after: JsonObject): string[] {
	const beforeExtensions = before.extensions ?? {}
	const afterExtensions = after.extensions ?? {}
	const browserExtensions = ["firefox", "chrome"].flatMap(browser =>
		changedKeys(beforeExtensions[browser], afterExtensions[browser]).map(name => `${browser}/${name}`),
	)
	const vscodeExtensions = changedNestedKeys(beforeExtensions.vscode, afterExtensions.vscode)
		.map(name => `vscode/${name}`)
	const millenniumExtensions = ["plugins", "themes"].flatMap(kind =>
		changedKeys(beforeExtensions.millennium?.[kind], afterExtensions.millennium?.[kind])
			.map(name => `millennium/${kind}/${name}`),
	)

	return [...browserExtensions, ...vscodeExtensions, ...millenniumExtensions].sort()
}

function runGit(args: string[]): void {
	execFileSync("git", args, { stdio: "inherit" })
}

async function main(): Promise<void> {
	const diff = spawnSync("git", ["diff", "--quiet", "HEAD", "--", "assets/sources.json"])
	if (diff.error) throw diff.error
	if (diff.status === 0) {
		console.info("[INFO] Source database is unchanged; no update commit created.")
		return
	}
	if (diff.status !== 1) throw new Error("Could not compare assets/sources.json with HEAD.")

	const previous = JSON.parse(execFileSync("git", ["show", "HEAD:assets/sources.json"], { encoding: "utf8" })) as JsonObject
	const current = JSON.parse(await Bun.file("assets/sources.json").text()) as JsonObject
	const programs = changedKeys(previous.packages?.programs, current.packages?.programs)
	const protonRuntimes = changedKeys(previous.packages?.wine, current.packages?.wine)
	const extensions = extensionChanges(previous, current)
	const title = `ci(update-checker): update ${programs.length} programs, ${protonRuntimes.length} Proton runtimes, ${extensions.length} extensions`
	const sections = [
		["Programs", programs],
		["Proton runtimes", protonRuntimes],
		["Extensions", extensions],
	] as const
	const body = sections
		.filter(([, names]) => names.length > 0)
		.map(([label, names]) => `${label} (${names.length}):\n${names.map(name => `- ${name}`).join("\n")}`)
		.join("\n\n")

	runGit(["add", "--", "assets/sources.json"])
	const staged = spawnSync("git", ["diff", "--cached", "--quiet", "--", "assets/sources.json"])
	if (staged.error) throw staged.error
	if (staged.status === 0) {
		console.info("[INFO] No staged source database changes; no update commit created.")
		return
	}
	if (staged.status !== 1) throw new Error("Could not inspect staged source database changes.")

	const commitArgs = ["commit", "-m", title]
	if (body) commitArgs.push("-m", body)
	runGit(commitArgs)
}

runScript(main)
