{ pkgs, libs, ... }: {
    imports = [
        (libs.root "/common/programs/nixvim/_nixvim.nix")

        ./bash.nix
        ./starship.nix
        ./fastfetch.nix
        ./git.nix
    ];
}