{
  lib,
  pkgs,
  ...
} @ args: let
  proton = lib.importJSON ../../../assets/proton.json;

  mkProtonPackage = {
    pname,
    version,
    src,
  }:
    pkgs.stdenv.mkDerivation {
      inherit pname version;
      src = pkgs.fetchzip src;
      dontBuild = true;
      installPhase = ''
        mkdir -p $out
        cp -r ./* $out
      '';
    };

  extraArgs = args // {inherit mkProtonPackage proton;};
  packageFiles = import ./packages;
in
  lib.foldl' (acc: path: acc // (import path extraArgs)) {} packageFiles
