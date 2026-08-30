{ lib, ... }: {
  enable = true;
  openOnSetupFile = true;
  settings = {
    auto_reload_on_write = true;
    on_attach = lib.nixvim.mkRaw ''
      function(bufnr)
        local api = require("nvim-tree.api")
        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
      end
    '';
  };
}
