{ asa-lib, ... }: let
    defaultBash = import (asa-lib.root "/common/programs/bash.nix") {};
in {
    programs.bash =  {
        enable = true;
        shellOptions = defaultBash.shellOptions;
        shellAliases = defaultBash.shellAliases // {
            nrs = "sudo nixos-rebuild switch --flake /etc/nixos#server";
            flake-upgrade = "nix flake update";
        };
        initExtra = defaultBash.initExtra;
    };
}