#! /usr/bin/env nix-shell
#! nix-shell -i sh -p nix git

nix flake update --flake ./flakes/overlays
cp flakes/overlays/flake.lock flakes/cursors/flake.lock
cp flakes/overlays/flake.lock flakes/proton/flake.lock
nix flake update

git add flake.lock flakes/overlays/flake.lock flakes/cursors/flake.lock flakes/proton/flake.lock
if ! git diff --cached --quiet; then
    git commit -m "ci(flake.lock): update flake inputs $(date '+%H:%M:%S %d-%m-%Y')"
else
    echo "No changes in lock files to commit."
fi