{ inputs, pkgs, ... }: {
    # Import Modules
    imports = [
        ./hardware-configuration.nix
        ./home-manager.nix

        ./modules/networking.nix
        ./modules/packages.nix
        
        ./modules/services/_services.nix
        ./modules/systemd/_systemd.nix
        ./modules/virtualisation/_virtualisation.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;
    time.timeZone = "Asia/Ho_Chi_Minh";

    users.users.asakiyuki = {
        isNormalUser = true;
        extraGroups = [ "wheel" "docker" ];
    };

    system.stateVersion = "25.11";
}