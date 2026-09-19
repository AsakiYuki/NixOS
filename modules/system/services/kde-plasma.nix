{
  lib,
  config,
  ...
}: {
  services = lib.mkIf (lib.attrByPath ["device" "de" "kdePlasma" "enable"] false config) {
    desktopManager.plasma6.enable = true;
    xserver.enable = true;
  };
}
