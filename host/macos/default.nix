{pkgs, ...}: {
  home = {
    username = "asakiyuki";
    homeDirectory = "/Users/asakiyuki";
    stateVersion = "26.05";
  };

  home.packages = with pkgs; [
    git
    ripgrep
    jq
  ];

  programs.home-manager.enable = true;
}
