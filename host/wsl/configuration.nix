{ inputs, pkgs, nixos-wsl, root, libs, ... }: {
    # Import Modules
    imports = [
        (libs.root "/nixos-modules/desktop/configuration.nix")
    ];

    # NixOS Config
    time.timeZone = "Asia/Ho_Chi_Minh";

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;

    wsl.enable = true;
    wsl.defaultUser = "asakiyuki";

    system.stateVersion = "25.05";    
}

