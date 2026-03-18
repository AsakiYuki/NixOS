{ pkgs, ... }: {
    imports = [ ./steam.nix ];
    programs = {
        firefox.enable = true;
        chromium.enable = true;
    };
}