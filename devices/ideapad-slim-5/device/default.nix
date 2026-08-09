{...}: {
  device.wm.hyprland.extraConfig = ''
    TouchpadName = "gxtp5100:00-27c6:01e0-touchpad"
    ${builtins.readFile ./monitors.lua}
  '';
}
