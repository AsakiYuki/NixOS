{ inputs, pkgs, ... }: {
    # Import Modules
    imports = [
        ./hardware-configuration.nix
        ../../nixos-modules/server/default.nix
    ];

    system.stateVersion = "25.11";
}