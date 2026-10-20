#! /usr/bin/env nix-shell
#! nix-shell -i sh -p nix git bun vsce

set -e

function commit_update() {
    git add assets/sources.json
    git commit -m "$1" -m "$(cat "$2")"
}

bun install --frozen-lockfile

bun run check-packages-update
if [ -f packages-commit.txt ]; then
    commit_update \
        "ci(update-checker/packages): update packages infos $(date '+%H:%M:%S %d-%m-%Y')" \
        "packages-commit.txt"
else
    echo "[INFO] Cannot found any packages update!"
fi

bun run check-proton-update
if [ -f proton-commit.txt ]; then
    commit_update \
        "ci(update-checker/proton): update proton infos $(date '+%H:%M:%S %d-%m-%Y')" \
        "proton-commit.txt"
else
    echo "[INFO] Cannot found any proton packages update!"
fi

bun run check-vscode-extensions-update
if [ -f vscode-extensions-commit.txt ]; then
    commit_update \
        "ci(update-checker/vscode-extensions): update vscode extensions infos $(date '+%H:%M:%S %d-%m-%Y')" \
        "vscode-extensions-commit.txt"
else
    echo "[INFO] Cannot found any vscode extensions update!"
fi

bun run check-browser-extensions-update
if [ -f browser-extensions-commit.txt ]; then
    commit_update \
        "ci(update-checker/browser-extensions): update browser extensions $(date '+%H:%M:%S %d-%m-%Y')" \
        "browser-extensions-commit.txt"
else
    echo "[INFO] Cannot found any browser extension updates!"
fi

bun run check-millennium-update
if [ -f millennium-commit.txt ]; then
    commit_update \
        "ci(update-checker/millennium): update plugins infos $(date '+%H:%M:%S %d-%m-%Y')" \
        "millennium-commit.txt"
else
    echo "[INFO] Cannot found any Millennium plugin update!"
fi
