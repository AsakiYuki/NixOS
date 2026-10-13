{pkgs, ...}: {
  programs = {
    # Code editors
    nixvim.enable = true;
    jetbrains.idea.enable = true;
    jetbrains.datagrip.enable = true;
    android-studio.enable = true;
    antigravity.enable = true;
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

    git.settings.user = {
      name = "Asaki Yuki";
      email = "vantrong2007vn@gmail.com";
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
    prismlauncher.enable = true;
    bedrock-on-linux.enable = true;

    # Downloader
    qbittorrent.enable = true;

    # General
    dolphin.enable = true;
    proton-apps.enable = true;
    # winboat.enable = true;
    # easyeffects.enable = true;

    cider = {
      enable = true;
      package = pkgs.cider-2;
    };

    lmstudio = {
      enable = true;
      package = pkgs.lmstudio;
    };

    # Office
    libreoffice.enable = true;

    # Media
    vlc.enable = true;
    blender.enable = true;
    gimp.enable = true;
    davinci-resolve.enable = true;
    obs-studio.enable = true;
    photocraft.enable = true;

    # Browsers
    firefox.enable = true;
    chromium.enable = true;
    tor-browser.enable = true;

    zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
      profiles.default = {...}: {
        spaces."Study" = {
          id = "ae80085e-8bc0-4ed9-885c-9d3b09d6d6e3";
          position = 5;
          icon = "📗";
          pins = {
            "iNet" = {
              editedTitle = true;
              id = "63b3a644-d91f-4968-bf1f-4482bbcde296";
              position = 5001;
              url = "https://portal.inet.vn/";
            };
            "AP Poly" = {
              editedTitle = true;
              id = "01540ea6-8f9a-48ab-b8f4-e59a1a49e3f5";
              position = 5002;
              url = "https://ap.poly.edu.vn/sinh-vien";
            };
            "Byethost" = {
              editedTitle = true;
              id = "b5777088-4232-4de4-bb0f-a8f46a87075b";
              position = 5003;
              url = "https://cpanel.hyethost.com/";
            };
            "EduNext" = {
              editedTitle = true;
              id = "c24e2679-83e3-4bfd-a331-3fcc248e840f";
              position = 5004;
              url = "https://edunext.fpl.edu.vn/home";
            };
            "Udemy" = {
              editedTitle = true;
              id = "18cfdb8b-1214-4f73-b079-95602f37c41e";
              position = 5005;
              url = "https://fpl.udemy.com/";
            };
            "English" = {
              id = "6ae6b6df-afe7-4925-9289-ffcf1bb44bcc";
              position = 5050;
              isFolderCollapsed = true;
              isGroup = true;
              pins = {
                "Cambridge" = {
                  editedTitle = true;
                  id = "83bffc59-7e22-40e4-a5ca-c211f3ea14c2";
                  position = 5051;
                  url = "https://dictionary.cambridge.org/";
                };
                "Language Hub" = {
                  editedTitle = true;
                  id = "27e11f6d-602b-4f65-a0c4-ab2e9ba9e3db";
                  position = 5052;
                  url = "https://lms.languagehub.vn/";
                };
              };
            };
          };
        };
      };
    };
  };
}
