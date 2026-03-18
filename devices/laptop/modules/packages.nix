{ pkgs, ... }: {
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
}