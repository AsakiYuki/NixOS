{ inputs, pkgs, ... }: {
    home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        backupFileExtension = "bak";

        users.asakiyuki = {
            _module.args = {
                inputs = inputs;
                pkgs = pkgs;
            };

            imports = [
                ./users/asakiyuki/configuration.nix
            ];
        };
    };

    users.users = {
        asakiyuki = {
            isNormalUser = true;
            shell = pkgs.bash;
        };
    };
}
