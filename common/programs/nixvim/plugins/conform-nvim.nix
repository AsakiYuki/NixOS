{ ... }:
{
  enable = true;
  settings = {
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
