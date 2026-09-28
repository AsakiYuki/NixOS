{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./profiles/default
    ./extension-settings.nix
    ./private-browsing-extensions.nix
    ./policies.nix
  ];

  config.programs.zen-browser = lib.mkIf (!config.programs.disable-module.zen-browser && !pkgs.stdenv.isDarwin) {
    icon = lib.root "/assets/programs/zen-browser/icon.png";
  };
}
