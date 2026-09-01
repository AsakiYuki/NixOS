#! /usr/bin/env nix-shell
#! nix-shell -i sh -p nix git bun vsce

function commit() {
    git add $1
    git commit -m "$2" -m "$(cat commit.txt)"
    rm commit.txt
}

bun install --frozen-lockfile
bun run check-packages-update
if [ -f commit.txt ]; then
    commit assets/packages.json "ci(update-checker/packages): update packages infos $(date '+%H:%M:%S %d-%m-%Y')"
else
    echo "[INFO] Cannot found any packages update!"
fi

bun run check-vscode-extensions-update
if [ -f commit.txt ]; then
    commit assets/vscode.extensions.json "ci(update-checker/packages): update vscode extensions infos $(date '+%H:%M:%S %d-%m-%Y')"
else
    echo "[INFO] Cannot found any vscode extensions update!"
fi 

bun run check-proton-update
if [ -f commit.txt ]; then
    commit assets/proton.json "ci(update-checker/proton): update proton infos $(date '+%H:%M:%S %d-%m-%Y')"
else
    echo "[INFO] Cannot found any proton packages update!"
fi 