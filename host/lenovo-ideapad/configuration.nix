{ inputs, pkgs, root, libs, ... }: {
    # Import Modules
    imports = [
        ./hardware-configuration.nix
        (libs.root "/nixos-modules/desktop/configuration.nix")
    ];
    
    device = {
        flake-name = "lenovo-ideapad";

        services = {
            steam = true;
        };
    };
    
    system.stateVersion = "25.11";
}