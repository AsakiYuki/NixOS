{ ... }: {
  device = {
    dm.sddm.enable = true;
    dm.gdm.enable = false;

    de.kdePlasma.enable = true;
    de.gnome.enable = false;

    wm.niri.enable = false;
    wm.hyprland.enable = false;

    flatpak.enable = true;
  };
}
