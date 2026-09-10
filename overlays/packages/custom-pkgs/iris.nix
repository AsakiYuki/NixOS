{
  pkgs,
  data,
  lib,
  get-arch,
  ...
}: let
  inherit (data) iris;
  arch = get-arch {
    "x86_64-linux" = "amd64";
    "aarch64-linux" = "arm64";
  } "iris";
in (pkgs.stdenv.mkDerivation rec {
  pname = "iris";
  version = iris.version;

  src = pkgs.fetchzip {
    url = "https://github.com/versenilvis/IRIS/releases/download/v${version}/iris_linux_${arch}.tar.gz";
    hash = iris.hash.${arch};
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
