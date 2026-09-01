{
  pkgs,
  lib,
  ...
}: let
  data = (lib.importJSON ../../../../assets/packages.json).cider-2;
in
  pkgs.cider-2.overrideAttrs (prevAtts: rec {
    version = data.version;

    src = pkgs.fetchurl {
      url = "https://static.asakiyuki.com/packages/nixos/cider-v${version}-linux-x64.deb";
      hash = data.hash;
    };

    postInstall = builtins.replaceStrings ["--replace-fail"] ["--replace-warn"] prevAtts.postInstall;
  })
