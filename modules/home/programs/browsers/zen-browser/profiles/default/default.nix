{
  pkgs,
  lib,
  ...
}: {
  programs.zen-browser.profiles.default = {...}: {
    imports = [./keyboard-shortcuts.nix ./sine.nix];

    _module.args = {inherit pkgs lib;};
  };
}
