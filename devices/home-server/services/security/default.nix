{...}: {
  imports = [
    ./adguardhome.nix
    ./fail2ban.nix
    ./nginx.nix
    ./openssh.nix
    ./tailscale.nix
  ];
}
