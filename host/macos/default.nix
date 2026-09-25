{pkgs, ...}: {
  home.homeDirectory = "/Users/asakiyuki";

  programs = {
    vscodium.enable = true;
    zen-browser.enable = true;
  };

  home.packages = with pkgs; [
    git
    ripgrep
    jq
  ];
}
