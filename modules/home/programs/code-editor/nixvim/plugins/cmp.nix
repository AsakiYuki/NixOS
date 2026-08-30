{...}: {
  enable = true;
  autoEnableSources = true;

  settings = {
    sources = [
      {name = "nvim_lsp";}
      {name = "path";}
      {name = "luasnip";}
      {name = "buffer";}
    ];

    mapping = {
      "<C-Space>" = "cmp.mapping.complete()";
      "<C-d>" = "cmp.mapping.scroll_docs(-4)";
      "<C-f>" = "cmp.mapping.scroll_docs(4)";
      "<C-e>" = "cmp.mapping.abort()";
      "<CR>" = "cmp.mapping.confirm({ select = true })";
      "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
      "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
    };

    formatting.fields = ["kind" "abbr" "menu"];
  };
}
