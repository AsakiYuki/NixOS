{ ... }:
{
    programs.nixvim.plugins = {
        nvim-tree = import ./nvimtree.nix;
        web-devicons.enable = true;
        which-key.enable = true;
        treesitter.enable = true;
    };
}