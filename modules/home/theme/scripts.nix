{
  pkgs,
  lib,
  osconfig,
  ...
}: let
  cfg = osconfig.device.theme.catppuccin;

  catppuccin-gtk = pkgs.catppuccin-gtk.override {
    variant = cfg.flavor;
    accents = [cfg.accent];
    size = "compact";
  };
in {
  home.activation.copyGtkTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "$HOME/.themes/"

    if [ ! -d "$HOME/.themes/catppuccin-${cfg.flavor}-${cfg.accent}-compact" ]; then
        cp -r "${catppuccin-gtk}/share/themes/catppuccin-${cfg.flavor}-${cfg.accent}-compact" "$HOME/.themes/"
    fi

    if [ ! -d "$HOME/.themes/catppuccin-${cfg.flavor}-${cfg.accent}-compact-hdpi" ]; then
        cp -r "${catppuccin-gtk}/share/themes/catppuccin-${cfg.flavor}-${cfg.accent}-compact-hdpi" "$HOME/.themes/"
    fi

    if [ ! -d "$HOME/.themes/catppuccin-${cfg.flavor}-${cfg.accent}-compact-xhdpi" ]; then
        cp -r "${catppuccin-gtk}/share/themes/catppuccin-${cfg.flavor}-${cfg.accent}-compact-xhdpi" "$HOME/.themes/"
    fi
  '';
}
