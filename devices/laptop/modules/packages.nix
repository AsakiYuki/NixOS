{ pkgs, unstable, ... }: {
    environment.systemPackages = (with pkgs; [
        vim
        wget
        git
        alsa-utils 
        alsa-ucm-conf
        easyeffects
        nodejs
        bun

        vesktop
        vscode
        obs-studio
        pavucontrol
        vlc

        fcitx5-material-color
    ]) ++ (with unstable; [
        proton-pass
        proton-authenticator
        prismlauncher
    ]) ++ [
        (pkgs.catppuccin-kde.override {
            flavour = [ "mocha" ];
        })
    ];
} 