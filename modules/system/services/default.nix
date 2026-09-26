{...}: {
  imports = [
    ./gdm.nix
    ./gnome.nix
    ./kde-plasma.nix
    ./openssh.nix
    ./sddm.nix
    ./envfs.nix
    ./tailscale.nix
    ./fail2ban.nix
  ];
}
