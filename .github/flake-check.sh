#! /usr/bin/env nix-shell
#! nix-shell -i sh -p nix git

nix flake update

git add flake.lock
if ! git diff --cached --quiet; then
    git commit -m "ci(flake.lock): update flake inputs $(date '+%H:%M:%S %d-%m-%Y')"
else
    echo "No changes in lock files to commit."
fi
