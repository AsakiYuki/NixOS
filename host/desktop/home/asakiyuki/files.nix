{
  pkgs,
  osconfig,
  lib,
  ...
}: let
  cfg = osconfig.device.theme.catppuccin;
  name = "${lib.toUpper (builtins.substring 0 1 cfg.flavor)}${builtins.substring 1 (-1) cfg.flavor}";
in {
  files = {
    force = {};

    # mkForce = {
    #   ".mozilla/firefox/default/search.json.mozlz4" = true;
    # };

    source = {
      ".config/qt5ct/colors/Catppuccin-${name}.conf" = "${pkgs.catppuccin-qt5ct}/share/qt5ct/colors/catppuccin-${cfg.flavor}-${cfg.accent}.conf";
      ".config/qt6ct/colors/Catppuccin-${name}.conf" = "${pkgs.catppuccin-qt5ct}/share/qt6ct/colors/catppuccin-${cfg.flavor}-${cfg.accent}.conf";
      ".config/menus/applications.menu" = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
    };

    symlink = {
      "SteamApps" = ".local/share/Steam/steamapps";
      "Development/Quickshell" = ".config/quickshell";
      ".local/share/honkers-railway-launcher/HSR" = "Games/HonkaiStarRail";

      # Zalo symlink
      "Games/zalo/drive_c/users/Public/Downloads" = "Downloads";
      "Games/zalo/drive_c/users/Public/Documents" = "Documents";

      # KDE Symlinks
      "Development/KDE-Widget" = ".local/share/plasma/plasmoids";
      "Development/SplashScreen" = ".local/share/plasma/look-and-feel";
      "Development/DesktopEffects" = ".local/share/kwin/effects";
    };
  };
}
