{ ... }@inputs:
{
    programs.nixvim.plugins = {
        nvim-tree = import ./nvimtree.nix;
        cmp = import ./cmp.nix inputs;
        lps = import ./lsp.nix inputs;

        web-devicons.enable = true;
        which-key.enable = true;
        treesitter.enable = true;
        lualine.enable = true;
        neoscroll.enable = true;
        lz-n.enable = true;
        image.enable = true;
        nvim-autopairs.enable = true;
        bufferline.enable = true;
        luasnip.enable = true;
    };
}