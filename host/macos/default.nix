{pkgs, ...}: {
  home.homeDirectory = "/Users/asakiyuki";

  programs = {
    bash.enable = true;
    vscodium.enable = true;
    zen-browser.enable = true;
    cider = {
      enable = true;
      package = pkgs.cider-2;
    };
  };

  home.packages = with pkgs; [
    git
    ripgrep
    jq
  ];
}
