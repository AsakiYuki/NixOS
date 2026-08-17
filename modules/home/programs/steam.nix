{pkgs, ...}: {
  programs.steam = {
    protonPackages = with pkgs; [
      cachyos-proton-11-0_20260703
      ge-proton-11-5
    ];
  };
}
