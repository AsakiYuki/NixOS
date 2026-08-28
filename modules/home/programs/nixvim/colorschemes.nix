{osconfig, ...}: let
  cfg = osconfig.device.theme.catppuccin;
  flavour = cfg.flavour;
in {
  colorschemes.catppuccin = {
    enable = true;
    settings = {
      flavour = flavour;
    };
  };
}
