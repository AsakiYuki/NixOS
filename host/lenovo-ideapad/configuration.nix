{ inputs, pkgs, ... }: {
    # Import Modules
    imports = [
        ./hardware-configuration.nix
        ../../nixos-modules/desktop/configuration.nix
    ];

    system.stateVersion = "25.11";
}