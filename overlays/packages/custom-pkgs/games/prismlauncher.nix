{
  pkgs,
  lib,
  ...
}:
if (pkgs.stdenv.isDarwin)
then let
  inherit (pkgs.prismlauncher) pname meta;
in (pkgs.stdenv.mkDerivation rec {
  inherit pname meta;
  name = "prismlauncher-11.1.1";

  src = pkgs.fetchzip {
    url = "https://github.com/PrismLauncher/PrismLauncher/releases/download/11.1.1/PrismLauncher-macOS-11.1.1.zip";
    hash = lib.fakeHash;
  };

  sourceRoot = ".";
  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications $out/bin
    cp -R "$src/Prism Launcher.app" $out/Applications
    makeWrapper "$out/Applications/Prism Launcher.app/Contents/MacOS/" $out/bin/${pname}

    runHook postInstall
  '';
})
else pkgs.prismlauncher
