{ ... }:
{
  enable = true;
  settings = {
    formatters = {
      prettier = {
        command = "prettier";
        args = [
          "--stdin-filepath"
          "$FILENAME"
          "--tab-width"
          "4"
        ];
      };
      nixfmt = {
        command = "nixfmt";
        args = [ "--width=4" ];
      };
    };

    formatters_by_ft = {
      javascript = [ "prettier" ];
      typescript = [ "prettier" ];
      json = [ "prettier" ];
      css = [ "prettier" ];
      html = [ "prettier" ];
      nix = [ "nixfmt" ];
    };

    format_on_save = {
      timeout_ms = 500;
      lsp_fallback = true;
    };
  };
}

