{ ... }: {
    services = {
        openssh = import ./openssh.nix {};
        cloudflare-dyndns = import ./cloudflare-dyndns.nix {};
        httpd = import ./httpd.nix {};
        mysql = import ./mysql.nix {};
        fail2ban.enable = true;
    };
}