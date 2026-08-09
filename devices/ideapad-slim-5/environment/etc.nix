{pkgs, ...}: {
  environment.etc = {
    "usr/share/hypr".source = pkgs.hyprland.outPath + "/share/hypr/";
  };
}
