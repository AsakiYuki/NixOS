{ inputs, pkgs, lib, ... }: let 
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

    home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        backupFileExtension = "bak";

        users = {
            asakiyuki = {
                _module.args = { inherit inputs pkgs; };
                imports = [ ./asakiyuki/configuration.nix ];
            };
        };
    };
}