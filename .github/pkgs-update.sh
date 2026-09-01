#! /usr/bin/env nix-shell
#! nix-shell -i sh -p nix git bun

bun install

bun run check-packages-update

if [ -f commit.txt ]; then
git add assets/packages.json
git commit \
    -m "ci(update-checker/packages): update packages infos $(date '+%H:%M:%S %d-%m-%Y')" \
    -m "$(cat commit.txt)"

rm commit.txt
else
    echo "[INFO] Cannot found any packages update!"
fi

bun run check-proton-update

if [ -f commit.txt ]; then
git add assets/proton.json
git commit \
    -m "ci(update-checker/proton): update proton infos $(date '+%H:%M:%S %d-%m-%Y')" \
    -m "$(cat commit.txt)"

rm commit.txt
else
    echo "[INFO] Cannot found any proton packages update!"
fi 