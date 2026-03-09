{ inputs, pkgs, nixos-wsl, ... }: {
    # Import Modules
    imports = [
        ./home-manager.nix
    ];

    # NixOS Config
    time.timeZone = "Asia/Ho_Chi_Minh";

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;

    wsl.enable = true;
    wsl.defaultUser = "asakiyuki";

    system.stateVersion = "25.05";    
}

