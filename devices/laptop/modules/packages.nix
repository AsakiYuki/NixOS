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

        easyeffects
        protonup-qt
        vesktop
        vscode
        obs-studio
        pavucontrol
        vlc

        wine
        wine64
        winetricks
        protontricks

        fcitx5-material-color
    ]) ++ (with unstable; [
        proton-pass
        proton-authenticator
        prismlauncher
    ]) ++ (with inputs; [
        hytale-launcher.packages.x86_64-linux.default
    ]) ++ [
        (pkgs.catppuccin-kde.override {
            flavour = [ "mocha" ];
        })
    ];
} 