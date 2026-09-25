{
  pkgs,
  lib,
  ...
}: {
  programs.zen-browser.profiles.default = {...}: {
    isDefault = true;
    imports = [
      ./workspaces
      ./extensions
      ./essential.nix
      ./keyboard-shortcuts.nix
      ./mods.nix
      ./presets.nix
      ./search.nix
      ./settings.nix
    ];

    _module.args = {
      inherit pkgs lib;
    };
  };
}
