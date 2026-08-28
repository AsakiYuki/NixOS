{
  osconfig,
  lib,
  ...
}: let
  cfg = osconfig.device.theme.catppuccin;
  flavour = cfg.flavour;
  colors = lib.catppuccin.${flavour};
in {
  programs.ghostty = {
    settings = {
      theme = "catppuccin-${flavour}";

      font-size = 9;
      font-family = "SauceCodePro NFP Bold";

      window-width = 230;
      window-height = 68;

      window-padding-x = 5;
      window-padding-y = 0;

      keybind = [
        "ctrl+shift+n=unbind"
        "ctrl+shift+i=unbind"
      ];
    };

    themes = {
      "catppuccin-${flavour}" = {
        background = "${colors.base}";
        cursor-color = "${colors.rosewater}";
        foreground = "${colors.text}";
        palette = [
          "0=${colors.surface1}"
          "1=${colors.red}"
          "2=${colors.green}"
          "3=${colors.yellow}"
          "4=${colors.blue}"
          "5=${colors.pink}"
          "6=${colors.teal}"
          "7=${colors.subtext1}"
          "8=${colors.surface2}"
          "9=${colors.red}"
          "10=${colors.green}"
          "11=${colors.yellow}"
          "12=${colors.blue}"
          "13=${colors.pink}"
          "14=${colors.teal}"
          "15=${colors.subtext0}"
        ];
        selection-background = "${colors.surface1}";
        selection-foreground = "${colors.text}";
      };
    };
  };
}
