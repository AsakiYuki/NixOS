#!/bin/sh
sudo nixos-rebuild build --flake "$(pwd)#$1"