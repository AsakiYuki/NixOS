{ pkgs, ... }:
{
  imports = [
    ./steam.nix
    ./ssh.nix
    ./nix-dl.nix
  ];

  programs = {
    gamemode.enable = true;
    fuse.userAllowOther = true;
  };
}

