{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git
    vim
    file
    wget
    tree
    screen

    nixfmt
    nixd
    nil

    alejandra

    p7zip-rar

    kdePackages.kio-extras
    kdePackages.kio-fuse

    lftp
    geode-cli
    cmake
    ninja
  ];
}
