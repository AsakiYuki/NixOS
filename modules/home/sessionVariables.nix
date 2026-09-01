{
  osconfig,
  config,
  pkgs,
  lib,
  ...
}: let
  isIncludedInPackages = pkg: (builtins.elem pkg osconfig.environment.systemPackages) || (builtins.elem pkg config.home.packages);
in {
  home.sessionVariables = lib.mergeAttrsList [
    (lib.optionalAttrs (isIncludedInPackages pkgs.geode-cli) {
      GEODE_SDK = "${config.home.homeDirectory}/Documents/Geode";
      GEODE_TARGET_PLATFORM = "Win64";
    })
    (lib.optionalAttrs osconfig.nixpkgs.config.allowUnfree {
      NIXPKGS_ALLOW_UNFREE = 1;
    })
  ];
}
