{
  osconfig ? {},
  config,
  pkgs,
  lib,
  ...
}: let
  systemPackages = lib.attrByPath ["environment" "systemPackages"] [] osconfig;
  isInSystemPackages = pkg: builtins.elem pkg systemPackages;
in {
  home.sessionVariables = lib.mkMerge [
    (lib.mkIf (isInSystemPackages pkgs.geode-cli) {
      GEODE_SDK = "${config.home.homeDirectory}/Documents/Geode";
      GEODE_TARGET_PLATFORM = "Win64";
    })
    (lib.mkIf (lib.attrByPath ["nixpkgs" "config" "allowUnfree"] false osconfig) {
      NIXPKGS_ALLOW_UNFREE = 1;
    })
  ];
}
