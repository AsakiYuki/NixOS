{ inputs, asa-lib, ... }:
{
    imports = [
        ./hardware-configuration.nix
        (asa-lib.root "/modules/desktop/default.nix")
    ];

    asa = {
        system = {
            name = "lenovo-ideapad-slim-5";
        };
        home = {
            cursors = "aemeath";
        };
    };

    system.stateVersion = "25.11";
}