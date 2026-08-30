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
  home.sessionVariables = {
    GEODE_SDK = lib.mkIf isGeodeSDKInstalled "${config.home.homeDirectory}/Documents/Geode";
  };
}
