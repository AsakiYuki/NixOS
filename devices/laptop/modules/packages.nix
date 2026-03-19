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

        easyeffects
        protonup-qt
        vesktop
        vscode
        obs-studio
        pavucontrol
        antigravity
        chromium
        vlc

        wine
        wine64
        winetricks
        protontricks
        php

        fcitx5-material-color
    ]) ++ (with unstable; [
        proton-pass
        proton-authenticator
        prismlauncher
    ]) ++ (with inputs; [
        hytale-launcher.packages.${pkgs.system}.default
    ]) ++ [
        (pkgs.catppuccin-kde.override {
            flavour = [ "mocha" ];
        })
    ];
} 