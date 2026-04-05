{ pkgs, ... }@inputs:
{
  programs = import ./nix-ld.nix inputs // {
    zsh.enable = true;
  };
}

