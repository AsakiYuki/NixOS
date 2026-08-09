import { spawnStdout } from "./shell"
import { mkdtemp, writeFile, rm } from "fs/promises"
import { tmpdir } from "os"
import { join } from "path"

async function tryFetchHash(file_url: string, unpack: boolean, stripRoot: boolean): Promise<string> {
	const dir = await mkdtemp(join(tmpdir(), "fetchhash-"))
	const exprPath = join(dir, "fetch.nix")

	const fetcher = unpack
		? `fetchzip { url = "${file_url}"; hash = lib.fakeHash; stripRoot = ${stripRoot}; }`
		: `fetchurl { url = "${file_url}"; hash = lib.fakeHash; }`

	await writeFile(
		exprPath,
		`
    let pkgs = import <nixpkgs> {}; lib = pkgs.lib; inherit (pkgs) fetchzip fetchurl;
    in pkgs.${fetcher}
    `,
	)

	try {
		await spawnStdout("nix-build", [exprPath, "--no-out-link"])
		throw new Error("Unexpected: build succeeded with fakeHash")
	} catch (err: any) {
		const stderr: string = err.stderr ?? err.message ?? ""
		const match = stderr.match(/got:\s*(sha256-[A-Za-z0-9+/=]+)/)
		if (match) return match[1]

		if (unpack && stripRoot && stderr.includes("zip file must contain a single file or directory")) {
			await rm(dir, { recursive: true, force: true })
			return tryFetchHash(file_url, unpack, false)
		}

		throw new Error(`Could not find hash in output:\n${stderr}`)
	} finally {
		await rm(dir, { recursive: true, force: true }).catch(() => {})
	}
}

export async function fetchZipHash(file_url: string, unpack: boolean = true): Promise<string> {
	return tryFetchHash(file_url, unpack, true)
}
