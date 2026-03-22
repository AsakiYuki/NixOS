{ inputs, pkgs, unstable, ... }: {
    environment.systemPackages = (with pkgs; [
        vim
        wget
        git
        alsa-utils 
        alsa-ucm-conf
        nodejs
        bun
        mesa
        dav1d
        ffmpeg-full
        libva
        libva-utils
        libva-vdpau-driver
        docker-compose
        ntfs3g
        btop
        neovide
        sass
        ruby
        rPackages.gems
        bindfs

        easyeffects
        protonup-qt
        obs-studio
        pavucontrol
        antigravity
        chromium
        cider-2
        gimp
        waydroid-helper
        osu-lazer
        waydroid-nftables
        qbittorrent
        vlc

        wine
        wine64
        winetricks
        protontricks
        php

        fcitx5-material-color
        kdePackages.kde-gtk-config
    ]) ++ (with unstable; [
        proton-pass
        vscode
        proton-authenticator
        prismlauncher
        vesktop
        winboat
        freerdp
        lutris

        kdePackages.qtdeclarative
    ]) ++ (with inputs; [
        hytale-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default
    ]) ++ [
        (pkgs.catppuccin-kde.override {
            flavour = [ "mocha" ];
            accents = [ "sapphire" ];
        })

        (pkgs.catppuccin-gtk.override {
            variant = "mocha";
            accents = [ "sapphire" ];
        })
    ];
}   