{ pkgs, config, ... }:
{
  programs.nixvim.imports = [
    ./default.nix
    ./extra-packages.nix

    ./keymaps/_keymaps.nix

    ./plugins/_plugins.nix
    ./plugins/_extraPlugins.nix

    ./lua/_lua.nix
  ];
}
