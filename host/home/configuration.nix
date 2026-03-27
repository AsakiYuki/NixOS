{ inputs, pkgs, ... }: {
    # Import Modules
    imports = [
        ./hardware-configuration.nix
        ../../nixos-modules/server/configuration.nix
    ];

    system.stateVersion = "25.11";
}