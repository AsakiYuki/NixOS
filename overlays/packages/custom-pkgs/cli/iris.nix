{
  pkgs,
  data,
  lib,
  ...
}: let
  inherit (data.iris) version hash;

  pkg-hash = hash.${pkgs.stdenv.system} or (throw "Iris is not support current system: ${pkgs.stdenv.system}");
  pkg-url = "https://github.com/versenilvis/IRIS/releases/download/v${version}/iris_linux_${{
      "x86_64-linux" = "x64";
      "aarch64-linux" = "arm64";
    }.${
      pkgs.stdenv.system
    }}.tar.gz";
in (pkgs.stdenv.mkDerivation {
  pname = "iris";
  inherit version;

  src = pkgs.fetchzip {
    url = pkg-url;
    hash = pkg-hash;
    stripRoot = false;
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp iris $out/bin
    chmod +x $out/bin/iris
  '';

  meta = with lib; {
    description = "A shell auto-completion tool for your terminal";
    homepage = "https://github.com/versenilvis/IRIS";
    license = with licenses; [
      bsd0
    ];
  };
})
