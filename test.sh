#!/bin/sh
sudo nixos-rebuild switch --flake "$(pwd)#$1"