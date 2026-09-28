{
  pkgs,
  lib,
  ...
}: {
  config = {
    programs.zen-browser.profiles.default = {...}: {
      isDefault = true;
      imports = [
        ./workspaces
        ./extensions.nix
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
  };
}
