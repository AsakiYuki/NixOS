#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix git bun vsce

set -euo pipefail

if ! git diff --quiet HEAD -- assets/sources.json; then
	echo "[ERROR] Refusing to run with pre-existing changes to assets/sources.json." >&2
	exit 1
fi

bun install --frozen-lockfile

bun run check-packages-update
bun run check-proton-update
bun run check-vscode-extensions-update
bun run check-browser-extensions-update
bun run check-millennium-update
bun run scripts/update/commit-source-updates.ts
