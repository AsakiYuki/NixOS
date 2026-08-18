{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs;
  getPkg = name: lib.mkIf cfg.${name}.enable cfg.${name}.package;
  mkOpt = lib.mkProgramOption;
  mkOpts = lib.mkProgramsOption;
in {
  config = {
    networking.firewall = lib.mkIf cfg.steam.enable {
      allowedTCPPorts = lib.mkIf cfg.steam.allowSteamlinkPorts [27036 27037];
      allowedUDPPorts =
        (lib.optional cfg.steam.allowSteamlinkPorts [27031 27032 27033 27034 27035 27036])
        ++ (lib.optional cfg.steam.allowMultiplayerPorts [4380 3478 4379]);
    };

    environment.systemPackages =
      [
        (lib.mkIf config.virtualisation.waydroid.enable pkgs.cage-xtmapper)

        (getPkg "ffmpeg")
        (getPkg "cava")
        (getPkg "lsfg-vk")
        (getPkg "nodejs")
        (getPkg "bun")
        (getPkg "brightnessctl")
        (getPkg "ntfs3g")
        (getPkg "python")
        (getPkg "jdk")

        (getPkg "quickshell")
        (getPkg "papirus-icons")
      ]
      ++ lib.concatLists [
        (lib.optionals cfg.gcc.enable cfg.gcc.packages)
        (lib.optionals cfg.winepackages.enable cfg.winepackages.packages)
        (lib.optionals cfg.kde-packages.enable cfg.kde-packages.packages)
        (lib.optionals cfg.r-tensorflow.enable [cfg.r-tensorflow.package])
        (lib.optionals (cfg.hyprland-portals.enable && config.device.wm.hyprland.enable) cfg.hyprland-portals.packages)
        (lib.optionals cfg.llvm.enable cfg.llvm.packages)
      ];
  };

  options.programs = {
    cava = mkOpt pkgs "cava" {};
    ffmpeg = mkOpt pkgs "ffmpeg-full" {name = "ffmpeg";};
    lsfg-vk = mkOpt pkgs "lsfg-vk" {};
    nodejs = mkOpt pkgs "nodejs" {};
    bun = mkOpt pkgs "bun" {};
    brightnessctl = mkOpt pkgs "brightnessctl" {};
    ntfs3g = mkOpt pkgs "ntfs3g" {};
    python = mkOpt pkgs "python3" {name = "python";};
    jdk = mkOpt pkgs "jdk25" {name = "jdk-25";};
    quickshell = mkOpt pkgs "quickshell" {};
    papirus-icons = mkOpt pkgs "papirus-icon-theme" {name = "papirus-icon-theme";};

    steam = {
      allowSteamlinkPorts = lib.mkEnableOption "steam-link streaming ports";
      allowMultiplayerPorts = lib.mkEnableOption "Steam multiplayer and voice ports";
    };
    r-tensorflow = {
      enable = lib.mkEnableOption "R tensorflow";
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.rPackages.tensorflow;
      };
    };

    llvm = mkOpts "llvm" (with pkgs.llvmPackages; [llvm clang lld]);
    gcc = mkOpts "c" (with pkgs; [gcc]);
    winepackages = mkOpts "Wine and Proton utilities" (with pkgs; [wine wine64 winetricks protontricks]);
    kde-packages = mkOpts "KDE utility packages" (with pkgs.kdePackages; [
      kservice
      kate
      gwenview
      qt5compat
      qtdeclarative
      qtimageformats
      qtsvg
      qtmultimedia
      kde-gtk-config
      kirigami
      ksvg
      qtbase
      plasma5support
      qttools
      plasma-sdk
    ]);
    hyprland-portals = mkOpts "XDGP for hyprland" (with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ]);
  };
}
