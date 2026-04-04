{ pkgs, ... }:
{
    programs.nixvim = {
        enable = true;
        colorschemes.catppuccin.enable = true;
    };
    
    imports = [
        ./keymaps/_keymaps.nix

        ./plugins/_plugins.nix
        ./plugins/_extraPlugins.nix
    ];
}