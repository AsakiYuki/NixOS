{ pkgs, ... }: {
    services = {
        openssh = import ./openssh.nix {};
        cloudflare-dyndns = import ./cloudflare-dyndns.nix {};
        httpd = import ./httpd.nix {};
        mysql = import ./mysql.nix { inherit pkgs; };
        logrotate = import ./logrotate.nix;
        fail2ban = import ./fail2ban.nix;

        xserver.enable = true;
        pulseaudio.enable = false;
        pipewire.enable = false;
        desktopManager.plasma6.enable = true;
    };
}