{
  lib,
  config,
  osconfig,
  ...
}:
lib.mkIf config.programs.btop.enable {
  programs.btop = let
    cfg = osconfig.device.theme.catppuccin;
    flavor = cfg.flavor;
    colors = lib.catppuccin.${flavor};
  in {
    settings = {
      color_theme = "catppuccin_${flavor}";
      theme_background = true;
      vim_keys = true;
      disable_mouse = true;
      terminal_sync = true;
      presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
    };

    themes = {
      "catppuccin_${flavor}" = ''
        theme[main_bg]="${colors.base}"
        theme[main_fg]="${colors.text}"
        theme[title]="${colors.text}"
        theme[hi_fg]="${colors.blue}"
        theme[selected_bg]="${colors.surface1}"
        theme[selected_fg]="${colors.blue}"
        theme[inactive_fg]="${colors.overlay1}"
        theme[graph_text]="${colors.rosewater}"
        theme[meter_bg]="${colors.surface1}"
        theme[proc_misc]="${colors.rosewater}"
        theme[cpu_box]="${colors.mauve}"
        theme[mem_box]="${colors.green}"
        theme[net_box]="${colors.maroon}"
        theme[proc_box]="${colors.blue}"
        theme[div_line]="${colors.overlay0}"
        theme[temp_start]="${colors.green}"
        theme[temp_mid]="${colors.yellow}"
        theme[temp_end]="${colors.red}"
        theme[cpu_start]="${colors.teal}"
        theme[cpu_mid]="${colors.sappire}"
        theme[cpu_end]="${colors.lavender}"
        theme[free_start]="${colors.mauve}"
        theme[free_mid]="${colors.lavender}"
        theme[free_end]="${colors.blue}"
        theme[cached_start]="${colors.sappire}"
        theme[cached_mid]="${colors.blue}"
        theme[cached_end]="${colors.lavender}"
        theme[available_start]="${colors.peach}"
        theme[available_mid]="${colors.maroon}"
        theme[available_end]="${colors.red}"
        theme[used_start]="${colors.green}"
        theme[used_mid]="${colors.teal}"
        theme[used_end]="${colors.sky}"
        theme[download_start]="${colors.peach}"
        theme[download_mid]="${colors.maroon}"
        theme[download_end]="${colors.red}"
        theme[upload_start]="${colors.green}"
        theme[upload_mid]="${colors.teal}"
        theme[upload_end]="${colors.sky}"
        theme[process_start]="${colors.sappire}"
        theme[process_mid]="${colors.lavender}"
        theme[process_end]="${colors.mauve}"
      '';
    };
  };
}
