{ inputs, pkgs, lib, ... }: {
    imports = [
        ./programs/_programs.nix
    ];

    home = {
        username = "asakiyuki";
        stateVersion = "25.11";
    };
}