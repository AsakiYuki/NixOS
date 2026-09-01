{
  pkgs,
  lib,
  ...
} @ args: let
  proton-pkgs-data = lib.importJSON ../../../assets/proton.json;
  proton-pkgs = [
    ./ge-proton.nix
    ./cachyos-proton.nix
    ./dw-proton.nix
  ];

  mkProtonPackage = {
    pname,
    version,
    src,
  }: (pkgs.stdenv.mkDerivation {
    inherit pname version;
    src = pkgs.fetchzip src;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out
      cp -r ./* $out
    '';
  });
in (lib.foldl' (acc: path:
    acc
    // (import path (args
      // {
        inherit mkProtonPackage;
        proton = proton-pkgs-data;
      }))) {}
proton-pkgs)
