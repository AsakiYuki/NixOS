{ inputs, pkgs, lib, ... }: {
    imports = [
        ./programs/_programs.nix
        ./modules/files/_files.nix
    ];

    home = {
        username = "asakiyuki";
        stateVersion = "25.11";
    };
}