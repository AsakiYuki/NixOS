{
  pkgs,
  data,
  ...
}: let
  inherit (data) cider-2;
in
  pkgs.cider-2.overrideAttrs (prevAtts: rec {
    version = cider-2.version;

    src = pkgs.fetchurl {
      url = "https://static.asakiyuki.com/packages/nixos/cider-v${version}-linux-x64.deb";
      hash = cider-2.hash;
    };

    postInstall = builtins.replaceStrings ["--replace-fail"] ["--replace-warn"] prevAtts.postInstall;
  })
