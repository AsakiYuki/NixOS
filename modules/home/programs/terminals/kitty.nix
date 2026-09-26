{
  lib,
  config,
  ...
}: let
  cfg = config.theme.catppuccin;
  flavour = cfg.flavour;
  colors = lib.catppuccin.${flavour};
in {
  programs.kitty = lib.mkIf (!config.programs.disable-module.kitty) {
    keybindings = {
      "ctrl+c" = "copy_to_clipboard";
      "ctrl+v" = "paste_from_clipboard";
    };

    settings = {
      window_padding_width = 2;
      window_padding_height = 2;

      cursor_shape = "beam";
      # background_opacity = 0.5;

      font_family = "Tahoma";
      font_size = 9;

      foreground = colors.text;
      background = colors.base;
      selection_foreground = colors.base;
      selection_background = colors.rosewater;

      cursor = colors.rosewater;
      cursor_text_color = colors.base;

      url_color = colors.rosewater;

      active_border_color = colors.lavender;
      inactive_border_color = colors.overlay0;
      bell_border_color = colors.yellow;

      wayland_titlebar_color = "system";
      macos_titlebar_color = "system";

      active_tab_foreground = colors.crust;
      active_tab_background = colors.mauve;
      inactive_tab_foreground = colors.text;
      inactive_tab_background = colors.mantle;
      tab_bar_background = colors.crust;

      mark1_foreground = colors.base;
      mark1_background = colors.lavender;
      mark2_foreground = colors.base;
      mark2_background = colors.mauve;
      mark3_foreground = colors.base;
      mark3_background = colors.sapphire;

      color0 = colors.surface1;
      color8 = colors.surface2;

      color1 = colors.red;
      color9 = colors.red;

      color2 = colors.green;
      color10 = colors.green;

      color3 = colors.yellow;
      color11 = colors.yellow;

      color4 = colors.blue;
      color12 = colors.blue;

      color5 = colors.pink;
      color13 = colors.pink;

      color6 = colors.teal;
      color14 = colors.teal;

      color7 = colors.subtext1;
      color15 = colors.subtext0;
    };
  };
}
