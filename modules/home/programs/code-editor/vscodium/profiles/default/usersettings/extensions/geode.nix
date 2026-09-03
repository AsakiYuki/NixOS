{
  pkgs,
  hmconfig,
  ...
}: {
  userSettings = {
    "geode.geodeCliPath" = "${pkgs.geode-cli}/bin/geode";
    "geode.geodeSdkPath" = "${hmconfig.home.homeDirectory}/Documents/Geode";
  };
}
