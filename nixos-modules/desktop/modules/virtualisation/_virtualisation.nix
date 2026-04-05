{ pkgs, ... }:
{
  imports = [
    ./docker.nix
  ];

  virtualisation = {
    waydroid.enable = true;
    waydroid.package = pkgs.waydroid-nftables;
  };
}

