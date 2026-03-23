{ inputs, pkgs, lib, ... }: {
    imports = [
        ./programs/_programs.nix
        ./packages/_packages.nix
        ./modules/files/_files.nix
    ];

    home = {
        username = "asakiyuki";
        stateVersion = "25.11";
        pointerCursor = import ./packages/castorice-cursor.nix { inherit pkgs; };
    };
}