{ pkgs, ... }: {
    imports = [
        ./steam.nix
        ./ssh.nix
        ./nix-dl.nix
    ];

    programs = {
        firefox.enable = true;
        chromium.enable = true;
        gamemode.enable = true;
        fuse.userAllowOther = true;
    };
}