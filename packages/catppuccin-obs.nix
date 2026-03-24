{ lib, pkgs, ... }: 
pkgs.stdenv.mkDerivation {
    pname = "catppuccin-obs";
    version = "main";

    src = pkgs.fetchzip {
        url = "https://github.com/catppuccin/obs/archive/refs/heads/main.zip";
        sha256 = lib.fakeSha256;
    };

    buildCommand = ''
        mkdir -p $out
        cp -r $src/obs-main/* $out/
    '';
}