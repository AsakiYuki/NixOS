{ ... }: {
    services = {
        openssh = import ./openssh.nix {};
        cloudflare-dyndns = import ./cloudflare-dyndns.nix {};
        fail2ban.enable = true;
    };
}