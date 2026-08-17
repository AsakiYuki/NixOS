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
  lib.mergeAttrsList (map (file: import file (args // {inherit proton mkProtonPackage;})) (
    map ({name, ...}: ./packages + "/${name}") (lib.attrsToList (builtins.readDir ./packages))
  ))
