{
  osconfig,
  config,
  pkgs,
  lib,
  ...
}: let
  isGeodeSDKInstalled =
    (builtins.elem pkgs.geode-cli osconfig.environment.systemPackages)
    || (builtins.elem pkgs.geode-cli config.home.packages);
in {
  home.sessionVariables = lib.mkIf isGeodeSDKInstalled {
    GEODE_SDK = "${config.home.homeDirectory}/Documents/Geode";
    GEODE_TARGET_PLATFORM = "Win64";
  };
}
