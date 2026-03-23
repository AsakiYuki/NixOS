{ inputs, pkgs, unstable, ... }: let 
    PKGS = with pkgs; [
        nodejs
        bun
        ffmpeg-full
        neovide
        sass
        ruby
        rPackages.gems


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
    ];
    
    UNSTABLE_PKGS = with unstable; [
        proton-pass
        vscode
        proton-authenticator
        prismlauncher
        vesktop
        winboat
        freerdp
        lutris
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
    home.packages = PKGS ++ UNSTABLE_PKGS ++ INPUTS_PKGS;
}