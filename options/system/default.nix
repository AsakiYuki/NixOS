{lib, ...}: {
  imports = [
    ./programs.nix
    ./environment.nix
  ];

  options.device = {
    flatpak.enable = lib.mkEnableOption "flatpak";
    pipewire.enable = lib.mkEnableOption "pipewire";
  };
}
