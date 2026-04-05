{ ... }: {
    programs = {
        ghostty = {
            enable = true;

            settings = {
                theme = "catppuccin-mocha";

                font-size = 10;
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
                catppuccin-mocha = {
                    background = "1e1e2e";
                    cursor-color = "f5e0dc";
                    foreground = "cdd6f4";
                    palette = [
                        "0=#45475a"
                        "1=#f38ba8"
                        "2=#a6e3a1"
                        "3=#f9e2af"
                        "4=#89b4fa"
                        "5=#f5c2e7"
                        "6=#94e2d5"
                        "7=#bac2de"
                        "8=#585b70"
                        "9=#f38ba8"
                        "10=#a6e3a1"
                        "11=#f9e2af"
                        "12=#89b4fa"
                        "13=#f5c2e7"
                        "14=#94e2d5"
                        "15=#a6adc8"
                    ];
                    selection-background = "353749";
                    selection-foreground = "cdd6f4";
                };
            };
        };

        kitty = {
            enable = false;

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
                
                foreground = "#cdd6f4";
                background = "#1e1e2e";
                selection_foreground = "#1e1e2e";
                selection_background = "#f5e0dc";

                cursor = "#f5e0dc";
                cursor_text_color = "#1e1e2e";

                url_color = "#f5e0dc";

                active_border_color = "#b4befe";
                inactive_border_color = "#6c7086";
                bell_border_color = "#f9e2af";

                wayland_titlebar_color = "system";
                macos_titlebar_color = "system";

                active_tab_foreground = "#11111b";
                active_tab_background = "#cba6f7";
                inactive_tab_foreground = "#cdd6f4";
                inactive_tab_background = "#181825";
                tab_bar_background = "#11111b";

                mark1_foreground = "#1e1e2e";
                mark1_background = "#b4befe";
                mark2_foreground = "#1e1e2e";
                mark2_background = "#cba6f7";
                mark3_foreground = "#1e1e2e";
                mark3_background = "#74c7ec";

                color0 = "#45475a";
                color8 = "#585b70";

                color1 = "#f38ba8";
                color9 = "#f38ba8";

                color2 = "#a6e3a1";
                color10 = "#a6e3a1";

                color3 = "#f9e2af";
                color11 = "#f9e2af";

                color4 = "#89b4fa";
                color12 = "#89b4fa";

                color5 = "#f5c2e7";
                color13 = "#f5c2e7";

                color6 = "#94e2d5";
                color14 = "#94e2d5";

                color7 = "#bac2de";
                color15 = "#a6adc8";
            };
        };
    };
}
