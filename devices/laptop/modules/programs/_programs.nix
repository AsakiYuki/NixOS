{ pkgs, ... }: {
    imports = [
        ./steam.nix
        ./ssh.nix
    ];

    programs = {
        firefox.enable = true;
        chromium.enable = true;
        fuse.userAllowOther = true;
    };
}