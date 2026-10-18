{
  pkgs,
  data,
  lib,
  ...
}: let
  inherit (data) geode-cli;
  source = geode-cli.source.${pkgs.stdenv.system}
    or (throw "Geode CLI is not supported on ${pkgs.stdenv.system}");
in (pkgs.stdenv.mkDerivation {
  pname = "geode-cli";
  version = geode-cli.version;

  src = pkgs.fetchurl {
    inherit (source) url hash;
  };

  nativeBuildInputs = [pkgs.unzip];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    install -m755 geode $out/bin/geode
  '';

  meta = with lib; {
    description = "Command-line utilities for working w/ geode";
    homepage = "https://geode-sdk.org/";
    license = with licenses; [
      bsl11
    ];
  };
})
