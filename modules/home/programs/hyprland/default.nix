{
  lib,
  osconfig ? {},
  ...
}: {
  imports = [
    ./settings
  ];

  wayland.windowManager.hyprland = lib.mkIf (lib.attrByPath ["device" "wm" "hyprland" "enable"] false osconfig) {
    enable = true;
    xwayland.enable = true;
  };
}
