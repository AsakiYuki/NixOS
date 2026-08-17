{lib, ...} @ args: let
  protons = lib.importJSON ../../../assets/proton.json;
  mkProtonPackage = {
    pname,
    version,
    src,
  }: {
    inherit pname version src;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out
      cp -r ./* $out
    '';
  };
in
  lib.mergeAttrsList (map (file: import file (args // {inherit protons mkProtonPackage;})) [
    ./ge-proton-packages.nix
  ])
