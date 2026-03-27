{ pkgs, ... }: {
    imports = [
        ./users/users.nix
        ./options/_options.nix.nix

        ./modules/services/_services.nix
        ./modules/security/_security.nix
        ./modules/programs/_programs.nix
        ./modules/systemd/_systemd.nix
        ./modules/virtualisation/_virtualisation.nix

        ./modules/hardware.nix
        ./modules/networking.nix
        ./modules/boot.nix
        ./modules/packages.nix
        ./modules/fonts.nix
        ./modules/udev.nix
        ./modules/fileSystems.nix
    ];

    nixpkgs.config.allowUnfree = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    time.timeZone = "Asia/Ho_Chi_Minh";

    i18n.inputMethod = {
        enable = true;
        type = "fcitx5";

        fcitx5.addons = with pkgs; [
            fcitx5-bamboo
        ];
    };
}