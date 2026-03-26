{ inputs, pkgs, ... }: {
    # Import Modules
    imports = [
        ./hardware-configuration.nix
        ../../nixos-modules/laptop/default.nix
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

    system.stateVersion = "25.11";
}