{
  pkgs,
  lib,
  ...
}:
{
  config = {
    programs.zen-browser.profiles.default = { ... }: {
      isDefault = true;
      imports = [
        ../../../shared/search.nix
        ../../../shared/settings.nix
        ./workspaces
        ./extensions.nix
        ./essential.nix
        ./keyboard-shortcuts.nix
        ./mods.nix
        ./presets.nix
        ./settings.nix
      ];

      _module.args = {
        inherit pkgs lib;
      };
    };
  };
}
