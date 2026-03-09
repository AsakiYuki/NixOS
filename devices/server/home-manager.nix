{ inputs, pkgs, ... }: {
    home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        backupFileExtension = "bak";

        users = {
            asakiyuki = {
                _module.args = { inherit inputs pkgs; };
                imports = [ ./users/asakiyuki/configuration.nix ];
            };
        };
    };
}
