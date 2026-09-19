{
  lib,
  osconfig ? {},
  ...
}: {
  imports = [
    ./settings
  ];

  wayland.windowManager.hyprland = lib.mkIf osconfig.device.wm.hyprland.enable {
    enable = true;
    xwayland.enable = true;
  };
}
