{
  pkgs,
  lib,
  ...
}:
if (pkgs.stdenv.isDarwin)
then let
  inherit (pkgs.prismlauncher) pname meta;
in (pkgs.stdenv.mkDerivation {
  inherit pname meta;
  src = pkgs.fetchzip {
    url = "https://github.com/PrismLauncher/PrismLauncher/releases/download/11.1.1/PrismLauncher-macOS-11.1.1.zip";
    hash = lib.fakeHash;
  };
})
else pkgs.prismlauncher
