import fs from "node:fs/promises"
import os from "node:os"
import path from "node:path"
import { spawn } from "node:child_process"

type Plugin = {
	name: string
	version: string
	description: string
	owner: string
	repo: string
	rev: string
	hash: string
	packageManager: "npm" | "pnpm" | "bun"
	depsHash: string
	[key: string]: unknown
}

type PluginData = { plugins: Record<string, Plugin> }

function run(command: string, args: string[], cwd?: string): Promise<{ code: number; output: string }> {
	return new Promise((resolve, reject) => {
		const child = spawn(command, args, { cwd, env: process.env })
		const output: string[] = []
		child.stdout.setEncoding("utf8").on("data", chunk => output.push(chunk))
		child.stderr.setEncoding("utf8").on("data", chunk => output.push(chunk))
		child.on("error", reject)
		child.on("close", code => resolve({ code: code ?? 1, output: output.join("") }))
	})
}

async function runChecked(command: string, args: string[], cwd?: string): Promise<string> {
	const result = await run(command, args, cwd)
	if (result.code !== 0) throw new Error(`${command} ${args.join(" ")} failed:\n${result.output}`)
	return result.output.trim()
}

async function nixHash(owner: string, repo: string, rev: string): Promise<string> {
	const url = `https://github.com/${owner}/${repo}/archive/${rev}.tar.gz`
	const output = await runChecked("nix-prefetch-url", ["--unpack", "--type", "sha256", url])
	const hash = output.split(/\s+/).find(token => /^[0-9abcdfghijklmnpqrsvwxyz]{52}$/.test(token))
	if (!hash) throw new Error(`Could not read Nix source hash for ${owner}/${repo}@${rev}:\n${output}`)
	return hash
}

function packageManager(manifest: Record<string, any>, files: Set<string>): Plugin["packageManager"] {
	const declared = String(manifest.packageManager ?? "").split("@")[0]
	if (["npm", "pnpm", "bun"].includes(declared)) return declared as Plugin["packageManager"]
	if (files.has("pnpm-lock.yaml")) return "pnpm"
	if (files.has("bun.lock") || files.has("bun.lockb")) return "bun"
	return "npm"
}

async function hashDependencies(names: string[], data: PluginData, root: string): Promise<void> {
	if (names.length === 0) return

	for (const name of names) data.plugins[name].depsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
	const namesNix = JSON.stringify(names)
	const expression = `let
  flake = builtins.getFlake (toString ./.);
  pkgs = import flake.inputs.nixpkgs.outPath {
    overlays = [ (_: pkgs: import ./overlays/packages (pkgs // { inherit pkgs; })) ];
  };
  names = ${namesNix};
in pkgs.linkFarm "millennium-plugin-dependencies" (map (name: {
  inherit name;
  path = pkgs.millennium-plugins.\"\${name}\".dependencies;
}) names)`

	const firstPass = await run("nix", [
		"build",
		"--impure",
		"--keep-going",
		"--extra-experimental-features",
		"nix-command flakes",
		"--no-link",
		"--expr",
		expression,
	], root)
	const hashes = new Map<string, string>()
	const mismatch = /hash mismatch in fixed-output derivation '\/nix\/store\/[0-9a-z]+-([^']+)-node-modules-[^']+\.drv':[\s\S]*?got:\s+(sha256-[^\s]+)/g
	for (const match of firstPass.output.matchAll(mismatch)) hashes.set(match[1], match[2])

	for (const name of names) {
		const hash = hashes.get(name)
		if (!hash) throw new Error(`Could not calculate dependency hash for ${name}. Nix output:\n${firstPass.output}`)
		data.plugins[name].depsHash = hash
	}
	await fs.writeFile(path.join(root, "assets/millennium.json"), JSON.stringify(data, null, 4) + "\n", "utf8")

	const validation = await run("nix", [
		"build",
		"--impure",
		"--keep-going",
		"--extra-experimental-features",
		"nix-command flakes",
		"--no-link",
		"--expr",
		expression,
	], root)
	if (validation.code !== 0) throw new Error(`Pinned dependency derivations failed to build:\n${validation.output}`)
}

async function buildPlugins(names: string[], root: string): Promise<void> {
	const namesNix = JSON.stringify(names)
	const expression = `let
  flake = builtins.getFlake (toString ./.);
  pkgs = import flake.inputs.nixpkgs.outPath {
    overlays = [ (_: pkgs: import ./overlays/packages (pkgs // { inherit pkgs; })) ];
  };
  names = ${namesNix};
in pkgs.linkFarm "millennium-plugin-build-check" (map (name: {
  inherit name;
  path = pkgs.millennium-plugins.\"\${name}\";
}) names)`
	const result = await run("nix", [
		"build",
		"--impure",
		"--keep-going",
		"--extra-experimental-features",
		"nix-command flakes",
		"--no-link",
		"--expr",
		expression,
	], root)
	if (result.code !== 0) throw new Error(`Updated Millennium plugins failed to build:\n${result.output}`)
}

async function main() {
	const root = process.cwd()
	const dataPath = path.join(root, "assets/millennium.json")
	const commitPath = path.join(root, "millennium-commit.txt")
	const originalFile = await fs.readFile(dataPath, "utf8")
	const data: PluginData = JSON.parse(originalFile)
	const temp = await fs.mkdtemp(path.join(os.tmpdir(), "millennium-plugin-database-"))
	await fs.rm(commitPath, { force: true })
	const database = path.join(temp, "PluginDatabase")
	const changes: string[] = []
	const changedNames: string[] = []

	try {
		await runChecked("git", [
			"clone", "--depth", "1", "--recurse-submodules", "--shallow-submodules",
			"https://github.com/SteamClientHomebrew/PluginDatabase.git", database,
		])
		const pluginRoot = path.join(database, "plugins")
		const pluginDirs = (await fs.readdir(pluginRoot, { withFileTypes: true }))
			.filter(entry => entry.isDirectory())
			.map(entry => entry.name)
			.sort((a, b) => a.localeCompare(b))
		const normalizedIds = new Set<string>()

		for (const id of pluginDirs) {
			const key = id.toLowerCase()
			if (normalizedIds.has(key)) throw new Error(`Plugin ID collision after lowercasing: ${id} -> ${key}`)
			normalizedIds.add(key)
			const sourceDir = path.join(pluginRoot, id)
			const rev = await runChecked("git", ["rev-parse", "HEAD"], sourceDir)
			const remote = await runChecked("git", ["remote", "get-url", "origin"], sourceDir)
			const normalizedRemote = remote
				.replace(/^git@github\.com:/, "https://github.com/")
				.replace(/\.git$/, "")
			const repoUrl = new URL(normalizedRemote)
			if (repoUrl.hostname !== "github.com") throw new Error(`Unsupported plugin repository URL: ${remote}`)
			const [owner, repo, ...extra] = repoUrl.pathname.replace(/^\//, "").split("/")
			if (!owner || !repo || extra.length) throw new Error(`Invalid plugin repository URL: ${remote}`)

			const previous = data.plugins[key]
			if (previous?.rev === rev) continue

			const manifestPath = path.join(sourceDir, "package.json")
			const manifest = JSON.parse(await fs.readFile(manifestPath, "utf8")) as Record<string, any>
			if (!manifest.scripts?.build) throw new Error(`${id} has no package.json build script`)
			const files = new Set(await fs.readdir(sourceDir))
			const hash = await nixHash(owner, repo, rev)
			const next: Plugin = {
				...(previous ?? {}),
				name: previous?.name || manifest.displayName || manifest.name || id,
				version: manifest.version || rev.slice(0, 7),
				description: manifest.description || previous?.description || "",
				owner,
				repo,
				rev,
				hash,
				packageManager: packageManager(manifest, files),
				depsHash: "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
			}
			data.plugins[key] = next
			changedNames.push(key)
			changes.push(`${previous ? "Updated" : "Added"}: ${key} ${previous?.version ?? "(new)"} -> ${next.version} (${rev})`)
			console.info(`[INFO] ${previous ? "Updated" : "Added"} ${key} at ${rev}`)
		}

		if (changedNames.length === 0) {
			console.info("[INFO] No new or updated approved Millennium plugins.")
			await fs.rm(commitPath, { force: true })
			return
		}

		try {
			await fs.writeFile(dataPath, JSON.stringify(data, null, 4) + "\n", "utf8")
			await hashDependencies(changedNames, data, root)
			await fs.writeFile(dataPath, JSON.stringify(data, null, 4) + "\n", "utf8")
			await buildPlugins(changedNames, root)
			await fs.writeFile(commitPath, changes.join("\n"), "utf8")
		} catch (error) {
			await fs.writeFile(dataPath, originalFile, "utf8")
			throw error
		}
		console.info(`[INFO] Updated ${changedNames.length} Millennium plugin(s).`)
	} finally {
		await fs.rm(temp, { recursive: true, force: true })
	}
}

main().catch(error => {
	console.error(error)
	process.exitCode = 1
})
