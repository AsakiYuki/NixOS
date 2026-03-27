{ pkgs, asa-lib, ... }: {
    imports = [
        ../../../../../common/programs/nixvim/_nixvim.nix
        
        ./bash.nix
        ./starship.nix
        ./fastfetch.nix
        ./git.nix
    ];
}