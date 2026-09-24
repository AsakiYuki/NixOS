{
  pkgs,
  lib,
  ...
}: {
  programs.zen-browser.profiles.default = {...}: {
    imports = [./keyboard-shortcuts.nix];

    _module.args = {inherit pkgs lib;};

    sine = {
      enable = true;
    };
  };
}
