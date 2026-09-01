{
  stdenv,
  fetchzip,
  lib,
}: let
  data = (lib.importJSON ../../../../assets/packages.json).geode-cli;
in
  stdenv.mkDerivation rec {
    pname = "geode-cli";
    version = data.version;

    src = fetchzip {
      url = "https://github.com/geode-sdk/cli/releases/download/v${version}/geode-cli-v${version}-linux.zip";
      hash = data.hash;
    };

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin
      cp geode $out/bin
      chmod +x $out/bin/geode
    '';

    meta = with lib; {
      description = "Command-line utilities for working w/ geode";
      homepage = "https://geode-sdk.org/";
      license = with licenses; [
        bsl11
      ];
    };
  }
