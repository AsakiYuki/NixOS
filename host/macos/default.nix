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
    cider = {
      enable = true;
      package = pkgs.cider-2;
    };
  };
}
