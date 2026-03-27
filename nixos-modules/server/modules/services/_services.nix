{ pkgs, ... }: {
    imports = [
        ./cloudflare-dyndns.nix
        ./fail2ban.nix
        ./httpd.nix
        ./logrotate.nix
        ./mysql.nix
        ./openssh.nix
	./adguardhome.nix
    ];

    services = {
        xserver.enable = true;
        pulseaudio.enable = false;
        pipewire.enable = false;
        desktopManager.plasma6.enable = true;
    };
}
