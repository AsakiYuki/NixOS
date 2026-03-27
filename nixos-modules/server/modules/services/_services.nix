{ pkgs, ... }: {
    imports = [
        ./openssh.nix
        ./cloudflare-dyndns.nix
        ./httpd.nix
        ./mysql.nix
        ./logrotate.nix
        ./fail2ban.nix
        ./minecraft-server.nix
    ];

    services = {
        openssh = import ./openssh.nix {};
        mysql = import ./mysql.nix { inherit pkgs; };

        xserver.enable = true;
        pulseaudio.enable = false;
        pipewire.enable = false;
        desktopManager.plasma6.enable = true;
    };
}