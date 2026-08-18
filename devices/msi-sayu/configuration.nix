{
  pkgs,
  lib,
  ...
}: {
  imports = [
    (lib.root "/users/sayu/configuration.nix")

    ./programs
    ./device.nix

    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Ho_Chi_Minh";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
}
