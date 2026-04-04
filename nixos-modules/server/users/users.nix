{ inputs, pkgs, lib, asa-lib, config, ... }: let
    osconfig = config;
in {
    users = {
        users = {
            asakiyuki = {
                isNormalUser = true;
                shell = pkgs.bash;
                extraGroups = [ "public" "wheel" "docker" "minecraft" ];
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
                _module.args = { inherit inputs pkgs osconfig asa-lib; };
                imports = [ 
                    inputs.nixvim.homeModules.nixvim
                    ./asakiyuki/configuration.nix
                ];
            };

            hoacaclord = {
                _module.args = { inherit inputs pkgs osconfig asa-lib; };
                imports = [ ./hoacaclord/configuration.nix ];
            };

            junko = {
                _module.args = { inherit inputs pkgs osconfig asa-lib; };
                imports = [ ./junko/configuration.nix ];
            };
        };
    };
}