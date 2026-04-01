{ inputs, pkgs, ... }: {
    environment.systemPackages = (with pkgs; [
        vim
        wget
        git
        alsa-utils
        alsa-ucm-conf
        
        mesa
        dav1d
        libva
        libva-utils
        libva-vdpau-driver
        docker-compose
        ntfs3g
        btop
        bindfs
        tree
        superfile
        p7zip

        freetype

        fcitx5-material-color
    ]) ++ (with pkgs.kdePackages; [
        kde-gtk-config
        qtdeclarative
        qt5compat
        kirigami
        ksvg
        qtbase
        plasma5support
        qttools
        plasma-sdk
    ]);
}   