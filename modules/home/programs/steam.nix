{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.steam = lib.mkIf (!config.programs.disable-module.steam) {
    protonPackages = with pkgs; [
      cachyos-proton-v3-latest
      ge-proton-latest
    ];
  };
}
