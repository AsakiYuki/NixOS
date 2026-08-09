{pkgs, ...}: {
  programs = {
    dconf.enable = true;
    ffmpeg.enable = true;
    nodejs.enable = true;
    ntfs3g.enable = true;
    python.enable = true;
    jdk.enable = true;
    bun = {
      enable = true;
      package = pkgs.bun-baseline;
    };
  };
}
