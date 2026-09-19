{
  osconfig ? {},
  config,
  pkgs,
  lib,
  ...
}: let
  systemPackages = lib.attrByPath ["environment" "systemPackages"] [] osconfig;
  isIncludedInPackages = pkg: (builtins.elem pkg systemPackages) || (builtins.elem pkg config.home.packages);
in {
  home.sessionVariables = lib.mergeAttrsList [
    (lib.optionalAttrs (isIncludedInPackages pkgs.geode-cli) {
      GEODE_SDK = "${config.home.homeDirectory}/Documents/Geode";
      GEODE_TARGET_PLATFORM = "Win64";
    })
    (lib.optionalAttrs (lib.attrByPath ["nixpkgs" "config" "allowUnfree"] false osconfig) {
      NIXPKGS_ALLOW_UNFREE = 1;
    })
  ];
}
