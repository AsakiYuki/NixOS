{ inputs, pkgs, ... }: {
    # Import Modules
    imports = [
        ./hardware-configuration.nix

        ./users/users.nix

        ./modules/services/_services.nix
        ./modules/security/_security.nix
        ./modules/programs/_programs.nix

        ./modules/hardware.nix
        ./modules/networking.nix
        ./modules/boot.nix
        ./modules/packages.nix
        ./modules/fonts.nix
    ];

    nixpkgs.config.allowUnfree = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    time.timeZone = "Asia/Ho_Chi_Minh";

    system.stateVersion = "25.11";
}