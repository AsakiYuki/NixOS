{
  pkgs,
  lib,
  ...
}: {
  programs.zen-browser.profiles.default = {...}: {
    imports = [
      ./keyboard-shortcuts.nix
      ./sine.nix
      ./presets.nix
    ];

    _module.args = {inherit pkgs lib;};
  };
}
