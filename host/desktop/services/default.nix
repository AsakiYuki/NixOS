{
  pkgs,
  config,
  lib,
  ...
}: {
  device.pipewire.enable = true;

  imports = [
    ./home
    ./openssh.nix
    ./fcitx5-lotus.nix
  ];

  services = {
    fail2ban.enable = true;
    cloudflare-warp.enable = true;
    udisks2.enable = true;
    upower.enable = true;

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
  };

  home-manager.users.asakiyuki.services = lib.mkIf config.device.wm.hyprland.enable {
    hyprpolkitagent.enable = true;
  };
}
