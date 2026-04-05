{ pkgs, config, ... }: let
    helpers = config.lib.nixvim; 
in {
    programs.nixvim.imports = [
        ./default.nix

        ./keymaps/_keymaps.nix

        ./plugins/_plugins.nix
        ./plugins/_extraPlugins.nix
    ];
}
