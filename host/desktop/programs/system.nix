{...}: {
  programs = {
    # Hyprland
    hyprland.enable = false;
    hyprland.xwayland.enable = true;
    hyprland-portals.enable = true;
    quickshell.enable = true;

    # Gaming
    steam = {
      enable = true;
      allowSteamlinkPorts = true;
      allowMultiplayerPorts = true;
      gamescopeSession.enable = true;
    };

    gamemode.enable = true;
    gamescope.enable = true;

    # General
    dconf.enable = true;
    ntfs3g.enable = true;

    # CLI
    llvm.enable = true;
    ffmpeg.enable = true;
    nodejs.enable = true;
    bun.enable = true;
    brightnessctl.enable = true;
    python.enable = true;
    winepackages.enable = true;
    jdk.enable = true;
    lsfg-vk.enable = true;
    r-tensorflow.enable = true;
    cava.enable = true;
    direnv.enable = true;

    # Themes
    papirus-icons.enable = true;

    # KDE
    kde-packages.enable = true;
  };
}
