{pkgs, ...}: {
  home.homeDirectory = "/Users/asakiyuki";

  home.packages = with pkgs; [
    atoll
  ];

  programs = {
    bash.enable = true;
    vscodium.enable = true;
    zen-browser.enable = true;
    fastfetch.enable = true;
    starship.enable = true;
    tmux.enable = true;

    git = {
      enable = true;
      settings = {
        user = {
          name = "Asaki Yuki";
          email = "vantrong2007vn@gmail.com";
        };
      };
    };

    nixcord = {
      enable = true;
      vesktop.enable = true;
      discord.enable = true;
    };

    nixvim.enable = true;

    ghostty = {
      enable = true;
      package = pkgs.ghostty-bin;
      settings = {
        font-size = 12;
        window-width = 210;
        window-height = 52;
      };
    };

    cider = {
      enable = true;
      package = pkgs.cider-2;
    };
  };
}
