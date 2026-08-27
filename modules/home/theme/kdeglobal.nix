{
  lib,
  osconfig,
  pkgs,
  config,
  ...
}: {
  programs.kde.kdeglobals = let
    cfg = osconfig.device.theme.catppuccin;
    flavor = "${lib.toUpper (builtins.substring 0 1 cfg.flavor)}${builtins.substring 1 (-1) cfg.flavor}";
    accent = "${lib.toUpper (builtins.substring 0 1 cfg.accent)}${builtins.substring 1 (-1) cfg.accent}";

    isTilingWindowsManager =
      (lib.attrByPath ["device" "wm" "hyprland" "enable"] false osconfig)
      || (lib.attrByPath ["device" "wm" "niri" "enable"] false osconfig);
  in {
    enable = isTilingWindowsManager;
    initExtra = lib.optionalString isTilingWindowsManager (
      builtins.readFile (
        (pkgs.catppuccin-kde.override {
          flavour = [cfg.flavor];
          accents = [cfg.accent];
        })
        + "/share/color-schemes/Catppuccin${flavor}${accent}.colors"
      )
    );
    config = lib.optionalAttrs isTilingWindowsManager {
      UiSettings = {
        ColorScheme = "qt6ct";
      };

      General = {
        TerminalApplication = let
          cfg = config.programs;
        in
          if (cfg.ghostty.enable)
          then "ghostty"
          else if (cfg.kitty.enable)
          then "kitty"
          else "";
      };

      Icons = {
        Theme = "Papirus";
      };
    };
  };
}
