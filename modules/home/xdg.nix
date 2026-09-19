{
  pkgs,
  lib,
  osconfig ? {},
  ...
}: let
  hyprlandEnabled = lib.attrByPath ["device" "wm" "hyprland" "enable"] false osconfig;
  kdePlasmaEnabled = lib.attrByPath ["device" "de" "kdePlasma" "enable"] false osconfig;
in {
  xdg.portal = lib.mkIf (hyprlandEnabled || kdePlasmaEnabled) {
    enable = true;
    xdgOpenUsePortal = true;
    config =
      {
        common.default = ["gtk"];
      }
      // lib.optionalAttrs hyprlandEnabled {
        hyprland.default = ["gtk" "hyprland"];
      }
      // lib.optionalAttrs kdePlasmaEnabled {
        "plasma".default = ["kde" "gtk"];
      };
    extraPortals =
      [pkgs.xdg-desktop-portal-gtk]
      ++ lib.optionals hyprlandEnabled [pkgs.xdg-desktop-portal-hyprland]
      ++ lib.optionals kdePlasmaEnabled [pkgs.kdePackages.xdg-desktop-portal-kde];
  };
}
