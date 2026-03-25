{ inputs, pkgs, lib, ... }: let 
    GLOBAL = import ../_global.nix;
in {
    users = {
        users = {
            asakiyuki = {
                isNormalUser = true;
                shell = pkgs.bash;
                extraGroups = [ "public" "wheel" "docker" ];
            };
            junko = {
                isNormalUser = true;
                shell = pkgs.bash;
                extraGroups = [ "public" ];
            };
            hoacaclord = {
                isNormalUser = true;
                shell = pkgs.zsh;
                extraGroups = [  ];
            };
            kvvl = {
                isNormalUser = true;
                shell = pkgs.bash;
                extraGroups = [  ];
            };
            static = {
                isSystemUser = true;
                group = "public";
            };
        };

        groups = {
            public = {};
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

            hoacaclord = {
                _module.args = { inherit inputs pkgs; };
                imports = [ ./hoacaclord/configuration.nix ];
            };

            kvvl = {
                _module.args = { inherit inputs pkgs; };
                imports = [ ./kvvl/configuration.nix ];
            };

            junko = {
                _module.args = { inherit inputs pkgs; };
                imports = [ ./junko/configuration.nix ];
            };
        };
    };
}