{
  pkgs,
  lib,
  ...
}: let
in (pkgs.stdenv.mkDerivation {
  pname = "photocraft";
  version = "0.8.2";

  src = pkgs.fetchzip {
    url = "https://github.com/storytold/photocraft/releases/download/v0.8.2/photocraft-0.8.2-linux-x86_64.tar.gz";
    hash = lib.fakeHash;
  };

  dontBuild = true;
})
