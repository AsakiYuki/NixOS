{ pkgs, asa-lib, ... }:
let
  bun-x64-linue-baseline = import (asa-lib.root "/packages/bun.nix") { inherit pkgs; };
in
{
  environment.systemPackages = with pkgs; [
    wget
    git
    p7zip
    python3
    nodejs
    unzip
    vim

    firefox
    screen

    tigervnc
    xorg.xinit
    kdePackages.plasma-workspace
    kdePackages.kglobalaccel
    kdePackages.kded

    bun-x64-linue-baseline
  ];
}

