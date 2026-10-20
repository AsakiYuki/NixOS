{
  pkgs,
  lib,
  sources,
  ...
}: let
  proton-data = sources.packages.wine;
  hostPlatform = pkgs.stdenv.hostPlatform;
  system = hostPlatform.system;

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
      lib.filterAttrs (_: value: value != null)
      (lib.mapAttrs' (ver: release: {
          name = "${pname}-${ver}";
          value = let
            src = release.${system} or null;
          in
            if src == null
            then null
            else mkProtonPackage {
              inherit pname src;
              version = ver;
            };
        })
        proton.releases);
    latest = versions."${pname}-${proton.latest}" or null;
    sourceName = proton.source_name.${system} or null;
  in
    versions
    // lib.optionalAttrs (latest != null && sourceName != null) {
      "${pname}-latest" = latest.overrideAttrs (_: {
        preFixup = ''
          substituteInPlace "$out/compatibilitytool.vdf" \
            --replace-fail "${sourceName}" "${proton.override_name}"
        '';
      });
    };
in
  if system != "x86_64-linux" && system != "aarch64-linux"
  then {}
  else lib.foldl' (acc: pname: acc // buildProton pname) {} (lib.attrNames proton-data)
