{pkgs, ...}: {
  home.homeDirectory = "/Users/asakiyuki";

  home.packages = with pkgs; [
    git
    ripgrep
    jq
  ];
}
