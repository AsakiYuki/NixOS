{lib, ...}: {
  imports = [
    ./pipewire.nix
    ./displayManager.nix
    ./power-profiles-daemon.nix
    ./xserver.nix
    ./tailscale.nix
    ./openssh.nix
    ./logind.nix
    ./udev.nix
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = lib.mkForce true;
  };
}
