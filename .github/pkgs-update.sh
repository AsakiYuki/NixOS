#! /usr/bin/env nix-shell
#! nix-shell -i sh -p nix git bun vsce

set -e

function commit() {
    git add $1
    git commit -m "$2" -m "$(cat "$3")"
}

bun install --frozen-lockfile

bun run check-packages-update
if [ -f packages-commit.txt ]; then
    commit assets/packages.json \
        "ci(update-checker/packages): update packages infos $(date '+%H:%M:%S %d-%m-%Y')" \
        "packages-commit.txt"
else
    echo "[INFO] Cannot found any packages update!"
fi

bun run check-proton-update
if [ -f proton-commit.txt ]; then
    commit assets/proton.json \
        "ci(update-checker/proton): update proton infos $(date '+%H:%M:%S %d-%m-%Y')" \
        "proton-commit.txt"
else
    echo "[INFO] Cannot found any proton packages update!"
fi

bun run check-vscode-extensions-update
if [ -f vscode-extensions-commit.txt ]; then
    commit assets/vscode.extensions.json \
        "ci(update-checker/vscode-extensions): update vscode extensions infos $(date '+%H:%M:%S %d-%m-%Y')" \
        "vscode-extensions-commit.txt"
else
    echo "[INFO] Cannot found any vscode extensions update!"
fi

bun run check-firefox-addons-update
if [ -f firefox-addons-commit.txt ]; then
    commit assets/firefox.addons.json \
        "ci(update-checker/firefox-addons): update firefox addons infos $(date '+%H:%M:%S %d-%m-%Y')" \
        "firefox-addons-commit.txt"
else
    echo "[INFO] Cannot found any firefox addons update!"
fi

bun run check-chrome-extensions-update
if [ -f chrome-extensions-commit.txt ]; then
    commit assets/chrome.extensions.json \
        "ci(update-checker/chrome-extensions): update Chrome extensions $(date '+%H:%M:%S %d-%m-%Y')" \
        "chrome-extensions-commit.txt"
else
    echo "[INFO] Cannot found any Chrome extension updates!"
fi

bun run check-millennium-update
if [ -f millennium-commit.txt ]; then
    commit assets/millennium.json \
        "ci(update-checker/millennium): update plugins infos $(date '+%H:%M:%S %d-%m-%Y')" \
        "millennium-commit.txt"
else
    echo "[INFO] Cannot found any Millennium plugin update!"
fi
