{ pkgs, ... }:
{
  imports = [
    ./lyrics.nix
  ];

  systemd.services = { };
}

