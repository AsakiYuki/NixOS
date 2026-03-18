{ pkgs, unstable, ... }: {
    environment.systemPackages = (with pkgs; [
        vim
        wget
        git
        alsa-utils 
        alsa-ucm-conf
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
        prismlauncher
    ]) ++ [
        (pkgs.catppuccin-kde.override {
            flavour = [ "mocha" ];
        })
    ];
}