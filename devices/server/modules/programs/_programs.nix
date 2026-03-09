{ pkgs, ... }: let 
    NIXDL = import ./nix-ld.nix { inherit pkgs; };
in {
    programs = NIXDL // {
    };
}