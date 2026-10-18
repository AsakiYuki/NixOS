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
	configKeys?: string[]
	[key: string]: unknown
}

type PluginData = { plugins: Record<string, Plugin> }
type Theme = {
	name: string
	version: string
	description: string
	owner: string
	repo: string
	rev: string
	hash: string
	storeId: string
	buildCommand?: string
	depsHash?: string
	[key: string]: unknown
}
type MillenniumData = PluginData & { themes?: Record<string, Theme> }

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

async function pluginConfigKeys(root: string): Promise<string[]> {
	const sourceExtensions = new Set([".js", ".jsx", ".ts", ".tsx", ".mjs", ".cjs", ".lua", ".py"])
	const ignoredDirectories = new Set([".git", "node_modules", "dist", "build", "coverage"])
	const files: string[] = []
	const visit = async (directory: string): Promise<void> => {
		for (const entry of await fs.readdir(directory, { withFileTypes: true })) {
			if (entry.isDirectory()) {
				if (!ignoredDirectories.has(entry.name)) await visit(path.join(directory, entry.name))
			} else if (entry.isFile() && sourceExtensions.has(path.extname(entry.name))) {
				files.push(path.join(directory, entry.name))
			}
		}
	}
	await visit(root)

	const keys = new Set<string>()
	const configAccessPatterns = [
		/\busePluginConfig\s*(?:<[^>]*>)?\s*\(\s*(["'])([^"'\n]+)\1/g,
		/\b(?:millennium\s*\.\s*)?config\s*\.\s*(?:get|set)\s*\(\s*(["'])([^"'\n]+)\1/g,
	]
	for (const file of files) {
		const source = await fs.readFile(file, "utf8")
		for (const pattern of configAccessPatterns) {
			for (const match of source.matchAll(pattern)) {
				const key = match[2].trim()
				if (key && !key.includes("${")) keys.add(key)
			}
		}
	}
	return [...keys].sort((a, b) => a.localeCompare(b))
}

async function hashDependencies(names: string[], data: PluginData, root: string): Promise<void> {
	if (names.length === 0) return

	for (const name of names) data.plugins[name].depsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
	const expression = `let
  flake = builtins.getFlake (toString ./.);
  pkgs = import flake.inputs.nixpkgs.outPath {
    overlays = [ (_: pkgs: import ./overlays/packages (pkgs // { inherit pkgs; })) ];
  };
  nixAttrName = id: builtins.replaceStrings [ "." ] [ "_" ] id;
  names = [ ${names.map(name => JSON.stringify(name)).join(" ")} ];
in pkgs.linkFarm "millennium-plugin-dependencies" (map (name: {
  inherit name;
  path = pkgs.millennium-plugins.\"\${nixAttrName name}\".dependencies;
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

async function hashThemeDependencies(names: string[], data: MillenniumData, root: string): Promise<void> {
	if (names.length === 0) return

	for (const name of names) data.themes![name].depsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
	const expression = `let
  flake = builtins.getFlake (toString ./.);
  pkgs = import flake.inputs.nixpkgs.outPath {
    overlays = [ (_: pkgs: import ./overlays/packages (pkgs // { inherit pkgs; })) ];
  };
  nixAttrName = id: builtins.replaceStrings [ "." ] [ "_" ] id;
  names = [ ${names.map(name => JSON.stringify(name)).join(" ")} ];
in pkgs.linkFarm "millennium-theme-dependencies" (map (name: {
  inherit name;
  path = pkgs.millennium-themes.\"\${nixAttrName name}\".dependencies;
}) names)`
	const firstPass = await run("nix", [
		"build", "--impure", "--keep-going", "--extra-experimental-features", "nix-command flakes",
		"--no-link", "--expr", expression,
	], root)
	const hashes = new Map<string, string>()
	const mismatch = /hash mismatch in fixed-output derivation '\/nix\/store\/[0-9a-z]+-([^']+)-node-modules-[^']+\.drv':[\s\S]*?got:\s+(sha256-[^\s]+)/g
	for (const match of firstPass.output.matchAll(mismatch)) hashes.set(match[1], match[2])

	for (const name of names) {
		const hash = hashes.get(name)
		if (!hash) throw new Error(`Could not calculate theme dependency hash for ${name}. Nix output:\n${firstPass.output}`)
		data.themes![name].depsHash = hash
	}
	await fs.writeFile(path.join(root, "assets/millennium.json"), JSON.stringify(data, null, 4) + "\n", "utf8")

	const validation = await run("nix", [
		"build", "--impure", "--keep-going", "--extra-experimental-features", "nix-command flakes",
		"--no-link", "--expr", expression,
	], root)
	if (validation.code !== 0) throw new Error(`Pinned theme dependency derivations failed to build:\n${validation.output}`)
}

async function buildPlugins(names: string[], root: string): Promise<void> {
	if (names.length === 0) return
	const expression = `let
  flake = builtins.getFlake (toString ./.);
  pkgs = import flake.inputs.nixpkgs.outPath {
    overlays = [ (_: pkgs: import ./overlays/packages (pkgs // { inherit pkgs; })) ];
  };
  nixAttrName = id: builtins.replaceStrings [ "." ] [ "_" ] id;
  names = [ ${names.map(name => JSON.stringify(name)).join(" ")} ];
in pkgs.linkFarm "millennium-plugin-build-check" (map (name: {
  inherit name;
  path = pkgs.millennium-plugins.\"\${nixAttrName name}\";
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

async function buildThemes(names: string[], root: string): Promise<void> {
	if (names.length === 0) return
	const expression = `let
  flake = builtins.getFlake (toString ./.);
  pkgs = import flake.inputs.nixpkgs.outPath {
    overlays = [ (_: pkgs: import ./overlays/packages (pkgs // { inherit pkgs; })) ];
  };
  nixAttrName = id: builtins.replaceStrings [ "." ] [ "_" ] id;
  names = [ ${names.map(name => JSON.stringify(name)).join(" ")} ];
in pkgs.linkFarm "millennium-theme-build-check" (map (name: {
  inherit name;
  path = pkgs.millennium-themes."\${nixAttrName name}";
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
	if (result.code !== 0) throw new Error(`Updated Millennium themes failed to build:\n${result.output}`)
}

async function themeBuildMetadata(owner: string, repo: string, rev: string, key: string): Promise<{ buildCommand?: string }> {
	const response = await fetch(`https://raw.githubusercontent.com/${owner}/${repo}/${rev}/package.json`)
	if (response.status === 404) return {}
	if (!response.ok) throw new Error(`Failed to inspect ${owner}/${repo}@${rev}/package.json: HTTP ${response.status}`)
	const manifest = await response.json() as Record<string, any>
	if (!manifest.scripts?.build) return {}

	const knownBuildCommands: Record<string, string> = {
		juxtematic: "npm run build -- client && npm run build -- web",
		"microsoft-office-2007-styled-theme": "npm run build",
		"windows-95": "npm run build -- steam",
	}
	return { buildCommand: knownBuildCommands[key] ?? "npm run build" }
}

function themeKey(name: string, id: string): string {
	const slug = name
		.toLowerCase()
		.normalize("NFKD")
		.replace(/[\u0300-\u036f]/g, "")
		.replace(/[^a-z0-9]+/g, "-")
		.replace(/^-|-$/g, "")
	return slug || `theme-${id.toLowerCase()}`
}

async function main() {
	const root = process.cwd()
	const configKeysOnly = process.argv.includes("--config-keys-only")
	const dataPath = path.join(root, "assets/millennium.json")
	const commitPath = path.join(root, "millennium-commit.txt")
	const originalFile = await fs.readFile(dataPath, "utf8")
	const data: MillenniumData = JSON.parse(originalFile)
	data.themes ??= {}
	const temp = await fs.mkdtemp(path.join(os.tmpdir(), "millennium-plugin-database-"))
	await fs.rm(commitPath, { force: true })
	const database = path.join(temp, "PluginDatabase")
	const changes: string[] = []
	const changedNames: string[] = []
	const changedConfigNames: string[] = []
	const changedThemeNames: string[] = []

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
			const configKeys = await pluginConfigKeys(sourceDir)
			const configKeysChanged = JSON.stringify(previous?.configKeys ?? []) !== JSON.stringify(configKeys)
			if (configKeysOnly) {
				if (previous && configKeysChanged) {
					data.plugins[key] = { ...previous, configKeys }
					changedConfigNames.push(key)
					changes.push(`Updated config keys: ${key} (${configKeys.length} key(s))`)
					console.info(`[INFO] Discovered ${configKeys.length} config key(s) for ${key}`)
				}
				continue
			}
			if (previous?.rev === rev && !configKeysChanged) continue

			if (previous?.rev === rev) {
				data.plugins[key] = { ...previous, configKeys }
				changedConfigNames.push(key)
				changes.push(`Updated config keys: ${key} (${configKeys.length} key(s))`)
				console.info(`[INFO] Discovered ${configKeys.length} config key(s) for ${key}`)
				continue
			}

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
				configKeys,
			}
			data.plugins[key] = next
			changedNames.push(key)
			changes.push(`${previous ? "Updated" : "Added"}: ${key} ${previous?.version ?? "(new)"} -> ${next.version} (${rev})`)
			console.info(`[INFO] ${previous ? "Updated" : "Added"} ${key} at ${rev}`)
		}

		if (!configKeysOnly) {
			const response = await fetch("https://steambrew.app/api/v2")
			if (!response.ok) throw new Error(`Failed to fetch Millennium themes: HTTP ${response.status}`)
			const catalog = await response.json()
			if (!Array.isArray(catalog)) throw new Error("Millennium theme API returned an unexpected catalog format")

			const normalizedThemeIds = new Set<string>()
			for (const item of catalog) {
				const name = String(item.name ?? "").trim()
				const storeId = String(item.data?.id ?? "").trim()
				const owner = String(item.data?.github?.owner ?? "").trim()
				const repo = String(item.data?.github?.repo ?? "").trim()
				const rev = String(item.commit_data?.oid ?? "").trim()
				if (!name || !storeId || !owner || !repo || !/^[0-9a-f]{40}$/i.test(rev)) {
					console.warn(`[WARN] Skipping Millennium theme with incomplete GitHub metadata: ${name || storeId || "(unnamed)"}`)
					continue
				}

				const key = themeKey(name, storeId)
				if (normalizedThemeIds.has(key)) throw new Error(`Millennium theme ID collision after lowercasing: ${name} -> ${key}`)
				normalizedThemeIds.add(key)

				const previous = data.themes[key]
				const version = String(item.version ?? rev.slice(0, 7))
				const description = String(item.description ?? "")
				if (
					previous?.rev === rev &&
					previous.version === version &&
					previous.description === description &&
					previous.storeId === storeId
				) continue

				const hash = previous?.rev === rev ? previous.hash : await nixHash(owner, repo, rev)
				const { buildCommand } = await themeBuildMetadata(owner, repo, rev, key)
				const next: Theme = { ...(previous ?? {}), name, version, description, owner, repo, rev, hash, storeId }
				if (buildCommand) {
					next.buildCommand = buildCommand
					next.depsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
				} else {
					delete next.buildCommand
					delete next.depsHash
				}
				data.themes[key] = next
				changedThemeNames.push(key)
				changes.push(`${previous ? "Updated" : "Added"} theme: ${key} ${previous?.version ?? "(new)"} -> ${version} (${rev})`)
				console.info(`[INFO] ${previous ? "Updated" : "Added"} theme ${key} at ${rev}`)
			}
		}

		if (changedNames.length === 0 && changedConfigNames.length === 0 && changedThemeNames.length === 0) {
			console.info(
				configKeysOnly
					? "[INFO] No Millennium plugin config keys changed."
					: "[INFO] No new or updated approved Millennium plugins or themes.",
			)
			await fs.rm(commitPath, { force: true })
			return
		}

		try {
			await fs.writeFile(dataPath, JSON.stringify(data, null, 4) + "\n", "utf8")
			await hashDependencies(changedNames, data, root)
			await hashThemeDependencies(changedThemeNames.filter(name => data.themes![name].buildCommand), data, root)
			await fs.writeFile(dataPath, JSON.stringify(data, null, 4) + "\n", "utf8")
			await buildPlugins(changedNames, root)
			await buildThemes(changedThemeNames, root)
			await fs.writeFile(commitPath, changes.join("\n"), "utf8")
		} catch (error) {
			await fs.writeFile(dataPath, originalFile, "utf8")
			throw error
		}
		console.info(
			`[INFO] Updated ${changedNames.length} plugin package(s), ${changedConfigNames.length} plugin config key list(s), and ${changedThemeNames.length} theme(s).`,
		)
	} finally {
		await fs.rm(temp, { recursive: true, force: true })
	}
}

main().catch(error => {
	console.error(error)
	process.exitCode = 1
})
