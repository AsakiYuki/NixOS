{
  osconfig,
  lib,
  pkgs,
  ...
}: let
  cfg = osconfig.device.theme.catppuccin;
in {
  # QT
  qt = {
    enable = true;
    platformTheme.name =
      if (lib.attrByPath ["device" "de" "kdePlasma" "enable"] false osconfig)
      then "kde"
      else "qtct";
    style = {
      package = with pkgs; [
        catppuccin-qt5ct
        catppuccin-kde
        kdePackages.breeze
      ];
    };
  };

  # GTK
  gtk = {
    enable = true;
    theme.name = "catppuccin-${cfg.flavour}-${cfg.accent}-compact";
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}
