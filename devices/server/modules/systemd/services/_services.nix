{ pkgs, ... }: {
    lyrics = import ./lyrics.nix { inherit pkgs; };
}