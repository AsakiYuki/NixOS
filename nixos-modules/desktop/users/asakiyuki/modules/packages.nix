{ inputs, pkgs, unstable, asa-lib, ... }: let 
    PKGS = with pkgs; [
        nodejs
        bun
        ffmpeg-full
        neovide
        sass
        ruby
        rPackages.gems
        wl-clipboard-rs

        waydroid-helper
        easyeffects
        protonup-qt
        pavucontrol
        antigravity
        chromium
        cider-2
        gimp
        qbittorrent
        davinci-resolve
        tigervnc
        vlc

        wineWowPackages.stable
        winboat
        php
    ];
    
    UNSTABLE_PKGS = with unstable; [
        gamescope
        
        proton-pass
        vscode
        proton-authenticator
        prismlauncher
        vesktop
        freerdp
        osu-lazer
        winetricks
        protontricks
        lmstudio
        
        lsfg-vk
        lsfg-vk-ui

        jetbrains.datagrip
    ];

    CUSTOM_PKGS = [
        (pkgs.callPackage (asa-lib.root "/packages/cage-xtmapper-0.2.0.nix") { })
    ];

    INPUTS_PKGS = with inputs; [
        hytale-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    THEMES = [
        (pkgs.catppuccin-kde.override {
            flavour = [ "mocha" ];
            accents = [ "sapphire" ];
        })

        (pkgs.catppuccin-gtk.override {
            variant = "mocha";
            accents = [ "sapphire" ];
        })
    ];
in  {
    home.packages = PKGS ++ UNSTABLE_PKGS ++ INPUTS_PKGS ++ CUSTOM_PKGS ++ THEMES;
}