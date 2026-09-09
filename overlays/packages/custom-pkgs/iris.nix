{
  pkgs,
  data,
  lib,
  ...
}: let
  inherit (data) iris;

  inherit (pkgs.stdenv.hostPlatform) system;

  archMap = {
    "x86_64-linux" = "amd64";
    "aarch64-linux" = "arm64";
  };

  targetArch =
    archMap.${system}
    or (throw "Unsupported system for iris: ${system}");
in (pkgs.stdenv.mkDerivation rec {
  pname = "iris";
  version = iris.version;

  src = pkgs.fetchzip {
    url = "https://github.com/versenilvis/IRIS/releases/download/v${version}/iris_linux_${targetArch}.tar.gz";
    hash = iris.hash.${system};
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
