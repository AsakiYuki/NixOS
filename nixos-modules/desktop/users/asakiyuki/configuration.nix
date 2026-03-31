{ inputs, pkgs, unstable, lib, asa-lib, osconfig, ... }: {
    imports = [
        ./programs/_programs.nix
        ./modules/files/_files.nix
        ./modules/activation.nix
        ./modules/packages.nix
    ];

    home = {
        username = "asakiyuki";
        stateVersion = "25.11";
        pointerCursor = (import (asa-lib.root "/packages/custom-cursors.nix") { name = osconfig.device.cursors; }) { inherit pkgs; };
    };
}