{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./chaotic.nix
    ./zram.nix

    ./hardware
    ./systemd
    ./mount
    ./network
    ./boot
    ./environment
    ./device
    ./services
    ./security
    ./packages
    ./programs

    (lib.root "/host/desktop")
  ];
}
