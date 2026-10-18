{
  lib,
  pkgs,
  unstable-pkgs,
  hmconfig,
  ...
}: let
  hasNativeGeodeCli = pkgs.stdenv.hostPlatform.system != "aarch64-darwin";
in {
  imports = [
    ../_lang/c-cpp
  ];

  userSettings = {
    "geode.geodeSdkPath" = "${hmconfig.home.homeDirectory}/Documents/Geode";
  } // lib.optionalAttrs hasNativeGeodeCli {
    "geode.geodeCliPath" = "${pkgs.geode-cli}/bin/geode";
  };

  extensions = with unstable-pkgs.vscode-extensions; [
    geodesdk.geode
  ];
}
