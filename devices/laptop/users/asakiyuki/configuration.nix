{ inputs, pkgs, unstable, lib, ... }: {
    imports = [
        ./programs/_programs.nix
        ./modules/files/_files.nix
        ./modules/activation.nix
        ./modules/packages.nix
    ];

    home = {
        username = "asakiyuki";
        stateVersion = "25.11";
        pointerCursor = import ./../../../../packages/elysia-cursors.nix { inherit pkgs; };
    };
}