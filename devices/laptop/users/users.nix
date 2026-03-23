{ inputs, pkgs, unstable, lib, ... }: {
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
            _module.args = { inherit inputs unstable pkgs; };
            imports = [ 
                inputs.nixvim.homeModules.nixvim
                inputs.nixcord.homeModules.nixcord
                
                ./asakiyuki/configuration.nix
            ];
        };
    };
}