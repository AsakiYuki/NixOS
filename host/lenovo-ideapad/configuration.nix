{ inputs, pkgs, root, asa-lib, ... }: {
    # Import Modules
    imports = [
        ./hardware-configuration.nix
        (asa-lib.root "/nixos-modules/desktop/configuration.nix")
    ];
    
    device = {
        flake-name = "lenovo-ideapad";
        cursors = "aemeath";

        services = {
            steam = true;
        };
    };
    
    system.stateVersion = "25.11";
}