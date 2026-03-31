{ inputs, pkgs, unstable, lib, asa-lib, ... }: let
    cursors-name = "aemeath";

    presetup-cursors = import (asa-lib.root "/packages/presetup-cursors.nix");
    custom-cursors = ((import (asa-lib.root "/packages/custom-cursors.nix")) presetup-cursors.${cursors-name}).cursors { inherit pkgs; };
in {
    imports = [
        ./programs/_programs.nix
        ./modules/files/_files.nix
        ./modules/activation.nix
        ./modules/packages.nix
    ];

    home = {
        username = "asakiyuki";
        stateVersion = "25.11";
        pointerCursor = custom-cursors;
    };
}