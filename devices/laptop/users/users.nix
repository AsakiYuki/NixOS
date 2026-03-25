{ inputs, pkgs, unstable, lib, config, ... }:
let 
    user = "asakiyuki";
    home = "/home/${user}";
in {
    users.users."${user}" = {
        isNormalUser = true;
        shell = pkgs.bash;
        extraGroups = [ "public" "wheel" "docker" ];
    };

    home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        backupFileExtension = "bak";

        users."${user}" = {
            _module.args = { inherit inputs config unstable pkgs home; };
            imports = [ 
                inputs.nixvim.homeModules.nixvim
                inputs.nixcord.homeModules.nixcord
                
                ./${user}/configuration.nix
            ];
        };
    };
}