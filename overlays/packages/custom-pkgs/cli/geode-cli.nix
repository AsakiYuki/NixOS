{
  pkgs,
  data,
  lib,
  ...
}: let
  inherit (data) geode-cli;
in (pkgs.stdenv.mkDerivation rec {
  pname = "geode-cli";
  version = geode-cli.version;

  src = pkgs.fetchzip {
    url = "https://github.com/geode-sdk/cli/releases/download/v${version}/geode-cli-v${version}-linux.zip";
    hash = geode-cli.hash;
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
})
