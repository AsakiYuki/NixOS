{ inputs, pkgs, ... }: {
    # Import Modules
    imports = [
        ./hardware-configuration.nix
    ];

    # BẮT BUỘC CHO MÁY MỚI: Sử dụng Kernel mới nhất để nhận driver Audio/Mic của AMD Ryzen AI
    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nixos";
    networking.networkmanager.enable = true;

    boot.kernelParams = [
        "snd_hda_intel.model=lenovo" 
        "snd_acp_config.dmic_acpi_check=1"
        "snd_acp_config.dmic_detect=1"
        "snd_sof_amd_acp63_enable=1"
    ];

    boot.extraModprobeConfig = ''
        options snd-hda-intel dmic_detect=0
    '';

    # Cấp quyền Realtime cho Pipewire hoạt động trơn tru (Bắt buộc)
    security.rtkit.enable = true;
    services.flatpak.enable = true;

    # Cấu hình lại Pipewire đầy đủ
    services.pipewire = {
        enable = true;
        alsa.enable = true;        # Hỗ trợ các app dùng ALSA
        alsa.support32Bit = true;  
        pulse.enable = true;
        wireplumber.enable = true; # Trình quản lý session âm thanh (rất quan trọng)
    };

    # Đảm bảo firmware độc quyền của AMD được tải đầy đủ
    hardware.enableRedistributableFirmware = true;
    hardware.firmware = [ pkgs.sof-firmware ];

    users.users.asakiyuki = {
        isNormalUser = true;
        extraGroups = [ "wheel" "audio" "video" ]; # Thêm user vào group audio
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
        pavucontrol 
        alsa-utils 
        alsa-ucm-conf

        (pkgs.catppuccin-kde.override {
            flavour = [ "mocha" ];
        })
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