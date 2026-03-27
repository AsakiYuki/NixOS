{ inputs, pkgs, ... }: {
    # Import Modules
    imports = [
        ./hardware-configuration.nix
        ../../nixos-modules/server/configuration.nix
    ];

    device = {
        admin-email = "vantrong2007vn@gmail.com";
        allow-ssh-users = [ "asakiyuki" "junko" "hoacaclord" ];
    };

    system.stateVersion = "25.11";
}