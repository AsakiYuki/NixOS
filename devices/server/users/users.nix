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
                extraGroups = [ "wheel" ];
            };
            static = {
                isSystemUser = true;
                group = "system";
                extraGroups = [ "public" ];
            };
        };

        groups = {
            system = {};
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

            junko = {
                _module.args = { inherit inputs pkgs; };
                imports = [ ./junko/configuration.nix ];
            };
        };
    };
}