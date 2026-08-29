{
  pkgs,
  unstable,
  ...
}: {
  programs = {
    # Code editors
    nixvim.enable = true;
    jetbrains.idea.enable = true;
    jetbrains.datagrip.enable = true;
    android-studio.enable = true;
    antigravity.enable = true;
    antigravity.package = unstable.antigravity-ide;
    zed-editor.enable = true;
    vscodium.enable = true;
    slack.enable = true;
    obsidian.enable = true;
    notion.enable = true;

    # Socials
    nixcord.enable = true;
    nixcord.discord.enable = true;
    nixcord.vesktop.enable = true;
    telegram.enable = true;

    # CLI Tools
    scrcpy.enable = true;
    tmux.enable = true;
    fastfetch.enable = true;
    starship.enable = true;
    bash.enable = true;
    poppler-utils.enable = true;
    img2pdf.enable = true;
    qpdf.enable = true;
    android-tools.enable = true;
    rustup.enable = true;
    bluetuith.enable = true;
    xprop.enable = true;
    wl-clipboard.enable = true;
    gcc.enable = true;
    tldr.enable = true;
    translate-shell.enable = true;
    yt-dlp = {
      enable = true;
      settings.cookies-from-browser = "firefox";
    };

    # RE Tools
    ghidra.enable = true;

    # Terminals
    ghostty.enable = true;
    kitty.enable = true;

    # Themes
    catppuccin.enable = true;
    nwg-look.enable = true;

    # Gaming
    mangohud.enable = true;
    osu.enable = true;
    lutris.enable = true;
    proton-utils.enable = true;
    prismlauncher.enable = true;

    steam = {
      protonPackages = with pkgs; [
        cachyos-proton-latest
        dw-proton-latest
        ge-proton-latest
      ];
    };

    # Downloader
    qbittorrent.enable = true;

    # General
    dolphin.enable = true;
    proton-apps.enable = true;
    winboat.enable = true;
    # easyeffects.enable = true;

    cider = {
      enable = true;
      package = pkgs.cider-2;
    };

    lmstudio = {
      enable = true;
      package = pkgs.lmstudio;
    };

    vscode = {
      enable = true;
      package = pkgs.vscode;
    };

    # Office
    libreoffice.enable = true;

    # Media
    vlc.enable = true;
    blender.enable = true;
    gimp.enable = true;
    davinci-resolve.enable = true;
    obs-studio.enable = true;

    # Browsers
    firefox.enable = true;
    zen-browser.enable = true;
    chromium.enable = true;
    tor-browser.enable = true;
  };
}
