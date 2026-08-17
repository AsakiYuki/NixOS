{
  lib,
  pkgs,
  ...
} @ args: let
  mkProtonPackage = {
    pname,
    version,
    src,
  }: {
    inherit pname version;
    src = pkgs.fetchzip src;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out
      cp -r ./* $out
    '';
  };
in
  lib.mapAttrs'
  (name: _: {
    name = name;
    value = import (./packages + "/${name}") (args // {inherit mkProtonPackage;});
  })
  (builtins.readDir ./packages)
