{osconfig, ...}: let
  cfg = osconfig.device.theme.catppuccin;
  flavour = cfg.flavour;
  accent = cfg.accent;
in {
  colorschemes.catppuccin = {
    enable = true;
    settings = {
      flavour = flavour;
    };
  };
}
