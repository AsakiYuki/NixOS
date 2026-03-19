{ ... }:
{
    programs.nixvim.plugins = {
        neo-tree = import ./neotree.nix;
        web-devicons.enable = true;
        which-key.enable = true;
        treesitter.enable = true;
    };
}