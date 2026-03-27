{ inputs, pkgs, ... }: {
    # Import Modules
    imports = [
        ./hardware-configuration.nix
        ../../nixos-modules/desktop/configuration.nix
    ];
    
    device.flake-name = "lenovo-ideapad";
    
    system.stateVersion = "25.11";
}