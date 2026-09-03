{
  osconfig,
  lib,
  ...
}: let
  cfg = osconfig.device.theme.catppuccin;
  name = "${lib.toUpper (builtins.substring 0 1 cfg.flavour)}${builtins.substring 1 (-1) cfg.flavour}";
  accent = cfg.accent;
in {
  userSettings = {
    "workbench.colorTheme" = "Catppuccin ${name}";
    "catppuccin.accentColor" = accent;
    "catppuccin.syncWithIconPack" = false;
  };
}
