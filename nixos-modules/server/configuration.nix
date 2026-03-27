{ inputs, ... }: {
    imports = [
        inputs.nix-minecraft.nixosModules.minecraft-servers

        ./users/users.nix

        ./options/_options.nix

        ./modules/nixpkgs.nix
        ./modules/networking.nix
        ./modules/packages.nix
        ./modules/services/minecraft-server.nix
        
        ./modules/services/_services.nix
        ./modules/systemd/_systemd.nix
        ./modules/virtualisation/_virtualisation.nix
        ./modules/programs/_programs.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    time.timeZone = "Asia/Ho_Chi_Minh";
}