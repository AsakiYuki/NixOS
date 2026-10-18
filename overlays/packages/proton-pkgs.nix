{
  pkgs,
  lib,
  ...
}: let
  proton-data = lib.importJSON ../../assets/proton.json;

  mkProtonPackage = {
    pname,
    version,
    src,
  }:
    pkgs.stdenv.mkDerivation {
      inherit pname version;
      src = pkgs.fetchurl src;
      dontBuild = true;
      unpackPhase = ''
        runHook preUnpack
        mkdir -p proton-source
        tar --extract --file "$src" --directory proton-source --strip-components=1
        cd proton-source
        runHook postUnpack
      '';
      installPhase = ''
        mkdir -p $out
        cp -r ./* $out
      '';
    };

  buildProton = pname: let
    proton = proton-data.${pname};
    versions =
      lib.mapAttrs' (ver: src: {
        name = "${pname}-${ver}";
        value = mkProtonPackage {
          inherit pname src;
          version = ver;
        };
      })
      proton.releases;
  in
    versions
    // {
      "${pname}-latest" = versions."${pname}-${proton.latest}".overrideAttrs (_: {
        preFixup = ''
          substituteInPlace "$out/compatibilitytool.vdf" \
            --replace-fail "${proton.source_name}" "${proton.override_name}"
        '';
      });
    };
in
  lib.foldl' (acc: pname: acc // buildProton pname) {} (lib.attrNames proton-data)
