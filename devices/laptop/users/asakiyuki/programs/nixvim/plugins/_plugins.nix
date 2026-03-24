{ ... }:
{
    programs.nixvim.plugins = {
        neo-tree = import ./neotree.nix;
        nvim-tree = ;
        web-devicons.enable = true;
        which-key.enable = true;
        treesitter.enable = true;
    };
}