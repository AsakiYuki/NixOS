{ ... }: {
    imports = [
        ./nixvim/_nixvim.nix
        
        ./_general.nix
        ./nixcord.nix
        ./bash.nix
        ./starship.nix
        ./fastfetch.nix
        ./git.nix
        ./ghostty.nix
        ./kitty.nix
        ./tmux.nix
    ];
}