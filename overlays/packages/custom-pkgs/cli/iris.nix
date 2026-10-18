{
  pkgs,
  data,
  lib,
  ...
}: let
  inherit (data.iris) version;
  pkg-source = data.iris.source.${pkgs.stdenv.system}
    or (throw "Iris is not supported on ${pkgs.stdenv.system}");
in (pkgs.stdenv.mkDerivation {
  pname = "iris";
  inherit version;

  src = pkgs.fetchzip {
    inherit (pkg-source) url hash;
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
