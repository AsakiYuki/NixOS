{pkgs, ...}: {
  home.homeDirectory = "/Users/asakiyuki";

  programs = {
    vscodium.enable = true;
    zen-browser.enable = true;
    cider-2.enable = true;
  };

  home.packages = with pkgs; [
    git
    ripgrep
    jq
  ];
}
