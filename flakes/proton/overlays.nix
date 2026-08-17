{
  lib,
  pkgs,
  ...
} @ args: let
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

  extraArgs = args // {inherit mkProtonPackage;};
  packageFiles = import ./packages;
in
  lib.foldl' (acc: path: acc // (import path extraArgs)) {} packageFiles
