{pkgs, ...}: let
  prefix = ".local/share/Steam/compatibilitytools.d";
in {
  config.home.file = {
    "${prefix}/ge-proton-11-5".source = pkgs.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton11-5/GE-Proton11-5-x86_64.tar.gz";
      hash = "sha256-Sbyi5zXMhPIKSotvL5LEZ2dbDoLpXRcCyuY9TsnBnus=";
    };
  };
}
