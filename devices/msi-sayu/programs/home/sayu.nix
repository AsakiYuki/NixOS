{pkgs, ...}: {
  programs = {
    zen-browser.enable = true;
    firefox.enable = true;

    lutris.enable = true;
    prismlauncher.enable = true;

    catppuccin.enable = true;

    bash.enable = true;
    fastfetch.enable = true;
    starship.enable = true;
    ghostty.enable = true;
    dolphin.enable = true;

    nixcord.enable = true;
    nixcord.discord.enable = true;
    nixcord.vesktop.enable = true;

    vscode = {
      enable = true;
      package = pkgs.vscode;
    };

    steam = {
      protonPackages = with pkgs; [
        cachyos-proton-11-0_20260703
        dw-proton-11-0_11
        ge-proton-11-5
      ];
    };
  };
}
