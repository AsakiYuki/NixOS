{ inputs, pkgs, lib, ... }: {
    users.users.asakiyuki = {
        isNormalUser = true;
        shell = pkgs.bash;
        extraGroups = [ "public" "wheel" "docker" ];
    };

    home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        backupFileExtension = "bak";

        users.asakiyuki = {
            _module.args = { inherit inputs pkgs; };
            imports = [ 
                inputs.nixvim.homeModules.nixvim
                ./asakiyuki/configuration.nix
            ];
        };
    };
}