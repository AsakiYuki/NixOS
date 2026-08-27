{
  lib,
  config,
  ...
}: {
  imports = [
    ./programs

    ./environment.nix
    ./services.nix
  ];

  options.device = {
    flatpak.enable = lib.mkEnableOption "flatpak";
    pipewire.enable = lib.mkEnableOption "pipewire";
  };

  config = {
    services.flatpak.enable = config.device.flatpak.enable;
  };
}
