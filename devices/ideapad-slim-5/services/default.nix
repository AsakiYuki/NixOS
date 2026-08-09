{...}: {
  imports = [
    ./dae.nix
    ./pipewire.nix
    ./displayManager.nix
    ./power-profiles-daemon.nix
    ./xserver.nix
    ./v2raya.nix
    ./tailscale.nix
    ./openssh.nix
    ./logind.nix
    ./udev.nix
  ];
}
