{lib, ...}: {
  imports = [
    ./programs
    ./services

    (lib.root "/users/asakiyuki/configuration.nix")
  ];

  virtualisation.docker.enable = true;
}
