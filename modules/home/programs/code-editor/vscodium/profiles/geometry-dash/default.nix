{
  unstable,
  pkgs,
  hmconfig,
  ...
}: {
  imports = [
    ../_lang/c-cpp
  ];

  userSettings = {
    "geode.geodeCliPath" = "${pkgs.geode-cli}/bin/geode";
    "geode.geodeSdkPath" = "${hmconfig.home.homeDirectory}/Documents/Geode";
  };

  extensions = with unstable.vscode-extensions; [
    geodesdk.geode
  ];
}
