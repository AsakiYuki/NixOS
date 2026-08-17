{pkgs, ...}: {
  programs.steam = {
    protonPackages = [
      pkgs.ge-proton-11-5
    ];
  };
}
