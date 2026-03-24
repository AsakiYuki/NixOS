{ ... }: {
    imports = [
        ./browsers/_browser.nix

        ./terminals.nix
        ./nixcord.nix
        ./obs-studio.nix
    ];
}