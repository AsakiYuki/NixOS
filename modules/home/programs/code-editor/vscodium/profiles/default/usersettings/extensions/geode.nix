{
  pkgs,
  config,
  ...
}: {
  programs.vscodium.profiles.default.userSettings = {
    "geode.geodeCliPath" = toString pkgs.geode-cli;
    "geode.geodeSdkPath" = "${config.home.homeDirectory}/Documents/Geode/";
  };
}
