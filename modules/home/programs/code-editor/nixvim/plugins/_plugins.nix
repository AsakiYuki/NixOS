{ unstable, ... }@inputs:
{
  plugins = {
    nvim-tree = import ./nvimtree.nix inputs;
    lsp = import ./lsp.nix inputs;
    lspkind = import ./lspkind.nix inputs;
    conform-nvim = import ./conform-nvim.nix inputs;
    which-key = import ./which-key.nix inputs;
    lint = import ./lint.nix inputs;
    telescope = import ./telescope.nix inputs;

    barbar = {
      enable = true;
      package = unstable.vimPlugins.barbar-nvim;
    };

    cmp = import ./cmp.nix inputs;
    cmp-nvim-lsp.enable = true;
    cmp-buffer.enable = true;
    cmp-path.enable = true;
    cmp_luasnip.enable = true;

    wakatime.enable = true;
    web-devicons.enable = true;
    lz-n.enable = true;
    treesitter.enable = true;
    lualine.enable = true;
    neoscroll.enable = true;
    image.enable = true;
    nvim-autopairs.enable = true;
    bufferline.enable = true;
    luasnip.enable = true;
    friendly-snippets.enable = true;
    indent-blankline.enable = true;
    toggleterm.enable = true;
    auto-save.enable = true;
    visual-multi.enable = true;
  };
}
