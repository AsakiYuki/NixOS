{
  pkgs,
  config,
  ...
}:
{
  programs.vscodium.profiles.default.userSettings = {
    "geode.geodeCliPath" = "${pkgs.geode-cli}/bin/geode";
    "geode.geodeSdkPath" = "${config.home.homeDirectory}/Documents/Geode";
  };
}
