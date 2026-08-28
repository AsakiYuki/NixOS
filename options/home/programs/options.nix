{
  lib,
  pkgs,
  config,
  osconfig,
  ...
}: let
  cfg = config.programs;
  getPkg = name: lib.mkIf cfg.${name}.enable cfg.${name}.package;
  mkOpt = lib.mkProgramOption;
  mkOpts = lib.mkProgramsOption;
in {
  config.home.packages =
    [
      (getPkg "slack")
      (getPkg "notion")
      (getPkg "winboat")
      (getPkg "file")
      (getPkg "catppuccin")
      (getPkg "poppler-utils")
      (getPkg "tor-browser")
      (getPkg "img2pdf")
      (getPkg "qpdf")
      (getPkg "ladybird")
      (getPkg "android-tools")
      (getPkg "android-studio")
      (getPkg "rustup")
      (getPkg "ghidra")
      (getPkg "qbittorrent")
      (getPkg "zen-browser")
      (getPkg "mangohud")
      (getPkg "telegram")
      (getPkg "vlc")
      (getPkg "gimp")
      (getPkg "libreoffice")
      (getPkg "osu")
      (getPkg "lmstudio")
      (getPkg "blender")
      (getPkg "xprop")
      (getPkg "davinci-resolve")
      (getPkg "wl-clipboard")
      (getPkg "easyeffects")
      (getPkg "scrcpy")
      (getPkg "pavucontrol")
      (getPkg "nwg-look")
      (getPkg "tldr")
      (getPkg "cider")
      (getPkg "geforce-now")

      (lib.mkIf cfg.jetbrains.idea.enable cfg.jetbrains.idea.package)
      (lib.mkIf cfg.jetbrains.datagrip.enable cfg.jetbrains.datagrip.package)
    ]
    ++ (lib.optionals cfg.proton-utils.enable cfg.proton-utils.packages)
    ++ (lib.optionals cfg.proton-apps.enable cfg.proton-apps.packages);

  options.programs = {
    yt-dlp.output = {
      directory = lib.mkOption {
        type = lib.types.str;
        default = "Downloads/yt-dlp";
      };
      format = lib.mkOption {
        type = lib.types.str;
        default = "%(title)s.%(ext)s";
      };
    };

    scrcpy = mkOpt pkgs "scrcpy" {};
    slack = mkOpt pkgs "slack" {};
    notion = mkOpt pkgs "notion-app-enhanced" {name = "notion";};
    winboat = mkOpt pkgs "winboat" {};
    file = mkOpt pkgs "file" {};
    qbittorrent = mkOpt pkgs "qbittorrent" {};
    tor-browser = mkOpt pkgs "tor-browser" {};
    qpdf = mkOpt pkgs "qpdf" {};
    ladybird = mkOpt pkgs "ladybird" {};
    poppler-utils = mkOpt pkgs "poppler-utils" {};
    img2pdf = mkOpt pkgs "img2pdf" {};
    android-tools = mkOpt pkgs "android-tools" {};
    android-studio = mkOpt pkgs "android-studio" {};
    rustup = mkOpt pkgs "rustup" {};
    ghidra = mkOpt pkgs "ghidra" {};
    tldr = mkOpt pkgs "tldr" {};
    vlc = mkOpt pkgs "vlc" {};
    gimp = mkOpt pkgs "gimp" {};
    lmstudio = mkOpt pkgs "lmstudio" {};
    wl-clipboard = mkOpt pkgs "wl-clipboard" {};
    blender = mkOpt pkgs "blender" {};
    xprop = mkOpt pkgs "xprop" {};
    nwg-look = mkOpt pkgs "nwg-look" {};
    davinci-resolve = mkOpt pkgs "davinci-resolve" {};
    geforce-now = mkOpt pkgs "geforce-now-electron" {};

    easyeffects = mkOpt pkgs "easyeffects" {name = "Easy Effects";};
    libreoffice = mkOpt pkgs "libreoffice-qt-fresh" {name = "libreoffice";};
    osu = mkOpt pkgs "osu-lazer-bin" {name = "osu-lazer";};
    telegram = mkOpt pkgs "telegram-desktop" {name = "telegram-desktop";};
    pavucontrol = mkOpt pkgs.lxqt "pavucontrol-qt" {name = "pavucontrol-qt";};
    cider = mkOpt pkgs "cider-2" {name = "cider-2";};
    zen-browser = mkOpt pkgs "zen-browser" {name = "zen-browser";};

    jetbrains = {
      datagrip = mkOpt pkgs.jetbrains "datagrip" {};
      idea = mkOpt pkgs.jetbrains "idea" {};
    };

    catppuccin = let
      cfg = osconfig.device.theme.catppuccin;
    in {
      enable = lib.mkEnableOption "catppuccin";
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.catppuccin-gtk.override {
          variant = cfg.flavour;
          accents = [cfg.accent];
          size = "compact";
        };
        description = "Catppuccin GTK package";
      };
      kde = lib.mkOption {
        type = lib.types.package;
        default = pkgs.catppuccin-kde.override {
          flavour = [cfg.flavour];
          accents = [cfg.accent];
        };
        description = "Catppuccin KDE package";
      };
    };

    proton-utils = mkOpts "proton-utils utils" (with pkgs; [protonup-qt protonplus]);
    proton-apps = mkOpts "proton-pass and proton-authenticator" (with pkgs; [proton-pass proton-authenticator]);
  };
}
