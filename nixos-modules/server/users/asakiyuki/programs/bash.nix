{ asa-lib, ... }: let
    defaultBash = import (asa-lib.root "/common/programs/bash.nix");
in {
    programs.bash =  {
        enable = true;
        shellOptions = defaultBash.shellOptions;
        shellAliases = defaultBash.shellAliases // {
            nrs = "sudo nixos-rebuild switch --flake /etc/nixos#server";
            flake-upgrade = "nix flake update";
            start-vnc = "Xvnc :1 -geometry 1600x900 -depth 24 -rfbauth ~/.vnc/passwd -rfbport 45682 & DISPLAY=:1 dbus-run-session startplasma-x11;"
        };
        initExtra = defaultBash.initExtra;
    };
}