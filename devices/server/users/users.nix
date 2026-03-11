{ pkgs, lib, ... }: let 
    GLOBAL = import ../_global.nix;
in {
    users = {
        users = {
            asakiyuki = {
                isNormalUser = true;
                shell = pkgs.bash;
                extraGroups = [ "wheel" "docker" ];
            };
            static = {
                isSystemUser = true;
                group = "static";
            };
        };

        groups = {
            static = {};
        };
    };
}