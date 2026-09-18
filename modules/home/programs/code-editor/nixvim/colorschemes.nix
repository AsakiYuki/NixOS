{hmconfig, ...}: let
  cfg = hmconfig.theme.catppuccin;
  flavour = cfg.flavour;
in {
  colorschemes.catppuccin = {
    enable = true;
    settings = {
      flavour = flavour;
    };
  };
}
