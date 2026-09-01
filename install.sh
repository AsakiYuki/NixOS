#!/bin/sh
nixos-install --flake ".#$1" --experimental-features "nix-command flakes"
