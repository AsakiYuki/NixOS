{ inputs, pkgs, unstable, ... }: let 
    PKGS = with pkgs; [
        nodejs
        bun
        ffmpeg-full
        neovide
        sass
        ruby
        rPackages.gems

        waydroid-helper
        easyeffects
        protonup-qt
        pavucontrol
        antigravity
        chromium
        cider-2
        gimp
        osu-lazer
        qbittorrent
        vlc

        wineWowPackages.stable
        winboat
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
        freerdp
        
        (bottles.override { removeWarningPopup = true; })
    ];

    CUSTOM_PKGS = [
        (pkgs.callPackage ../../../../../packages/cage-xtmapper-0.2.0.nix { })
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