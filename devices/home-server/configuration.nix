{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./network
    ./security
    ./services
    ./systemd
    ./users
    ./boot

    (lib.root "/host/server")
    (lib.root "/users/junko/configuration.nix")
    (lib.root "/users/hieze/configuration.nix")
  ];
}
