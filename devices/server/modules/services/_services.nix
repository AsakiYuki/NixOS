{ pkgs, ... }: {
    services = {
        openssh = import ./openssh.nix {};
        cloudflare-dyndns = import ./cloudflare-dyndns.nix {};
        httpd = import ./httpd.nix {};
        mysql = import ./mysql.nix { inherit pkgs; };
        fail2ban.enable = true;
    };
}