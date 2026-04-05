{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    nodePackages.prettier
  ];
}

