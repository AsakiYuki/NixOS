#!/bin/sh
set -e

HOST="${1:-asakiyuki@Macbook-Air-M5}"

if command -v home-manager >/dev/null 2>&1; then
    echo "==> Switching Home Manager generation for $HOST..."
    home-manager switch --flake ".#$HOST"
else
    echo "==> First time installation: building activation package for $HOST..."
    nix build ".#homeConfigurations.\"$HOST\".activationPackage" --extra-experimental-features "nix-command flakes"
    ./result/activate
    rm -f ./result
fi
