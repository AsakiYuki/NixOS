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
  home.sessionVariables = lib.mergeAttrsList [
    (lib.optionalAttrs isGeodeSDKInstalled {
      GEODE_SDK = "${config.home.homeDirectory}/Documents/Geode";
      GEODE_TARGET_PLATFORM = "Win64";
    })
    (lib.optionalAttrs osconfig.nixpkgs.config.allowUnfree {
      NIXPKGS_ALLOW_UNFREE = 1;
    })
  ];
}
