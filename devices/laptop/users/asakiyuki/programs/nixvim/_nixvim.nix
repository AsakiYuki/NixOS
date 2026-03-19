{ pkgs, ... }:
{
    programs.nixvim = {
        enable = true;
        colorschemes.catppuccin.enable = true;
    };
    
    imports = [
        ./plugins/_plugins.nix
        ./plugins/_extraPlugins.nix
    ];
}