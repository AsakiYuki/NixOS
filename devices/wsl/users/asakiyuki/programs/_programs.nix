{ pkgs, ... }: {
    imports = [
        ./bash.nix
        ./starship.nix
        ./fastfetch.nix
        ./git.nix
    ];
}