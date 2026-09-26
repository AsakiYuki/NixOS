{
  lib,
  pkgs,
  config,
  ...
}:
lib.mkIf (!config.programs.disable-module.zen-browser) {
  imports = [
    ./profiles/default
    ./policies.nix
  ];

  programs.zen-browser = lib.mkIf (!pkgs.stdenv.isDarwin) {
    icon = lib.root "/assets/programs/zen-browser/icon.png";
  };
}
