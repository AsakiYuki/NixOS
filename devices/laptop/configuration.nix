{ inputs, pkgs, ... }: {
    # Import Modules
    imports = [
        ./hardware-configuration.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nixos";
    networking.networkmanager.enable = true;

    services.pipewire = {
        enable = true;
        pulse.enable = true;
    };

    users.users.asakiyuki = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        packages = with pkgs; [
          tree
        ];
    };

    programs.firefox.enable = true;

    environment.systemPackages = with pkgs; [
        vim
        wget
        git
        vesktop
        vscode
        obs-studio
        vlc
    ];

    nixpkgs.config.allowUnfree = true;


    services = {
        desktopManager.plasma6.enable = true;
        displayManager.sddm = {
            enable = true;
            wayland.enable = true; 
        };
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    time.timeZone = "Asia/Ho_Chi_Minh";

    system.stateVersion = "25.11";
}