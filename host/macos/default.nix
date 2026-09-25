{pkgs, ...}: {
  home.homeDirectory = "/Users/asakiyuki";

  programs = {
    bash.enable = true;
    vscodium.enable = true;
    zen-browser.enable = true;
    fastfetch.enable = true;
    starship.enable = true;
    git.enable = true;
    tmux.enable = true;
    nixcord.enable = true;
    nixcord.discord.enable = true;
    nixcord.vesktop.enable = true;
    ghostty = {
      enable = true;
      package = pkgs.ghostty-bin;
      settings.font-size = 100;
    };
    cider = {
      enable = true;
      package = pkgs.cider-2;
    };
  };
}
