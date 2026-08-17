{pkgs, ...}: {
  programs.steam = {
    protonPackages = with pkgs; [
      cachyos-proton-11-0_20260703
      dw-proton-11-0_11
      ge-proton-11-5
    ];
  };
}
