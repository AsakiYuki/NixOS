{lib, ...}: {
  imports = [
    (lib.root "/users/sayu/configuration.nix")

    ./programs
    ./services

    ./device.nix
    ./boot.nix

    ./hardware-configuration.nix
  ];

  i18n.inputMethod.enable = true;
  networking.networkmanager.enable = true;
}
