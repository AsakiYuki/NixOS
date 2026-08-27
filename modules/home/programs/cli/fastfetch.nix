{
  osconfig,
  lib,
  ...
}: let
  cfg = osconfig.device.theme.catppuccin;
  colors = lib.catppuccin.${cfg.flavor};
  accent = colors.${cfg.accent};
in {
  programs.fastfetch = {
    settings = {
      logo = {
        padding.top = 1;
        color = {
          "1" = accent;
          "2" = colors.text;
          "3" = accent;
          "4" = colors.text;
          "5" = accent;
          "6" = colors.text;
        };
      };

      display = {
        color = {
          title = colors.text;
          output = colors.text;
          separator = "black";
        };

        bar = {
          width = 10;
          charTotal = " ";
          border.left = "[";
          border.right = "]";
          char.elapsed = "█";
          color = {
            border = "green";
            elapsed = "green";
            total = "black";
          };
        };

        percent = {
          type = 3;
          color = {
            green = "green";
            yellow = "yellow";
            red = "red";
          };
        };

        separator = "  ";
        brightColor = true;
      };

      modules = [
        {
          type = "title";
          format = " {user-name}@{host-name}";
          outputColor = "bright_yellow";
        }

        {
          type = "separator";
          string = "─";
          length = 24;
          outputColor = "white";
        }

        {
          type = "os";
          key = "╭─";
          keyColor = "green";
        }
        {
          type = "kernel";
          key = "├─󰌽";
          keyColor = "green";
        }
        {
          type = "shell";
          key = "├─";
          keyColor = "green";
        }
        {
          type = "packages";
          key = "├─󰆧";
          keyColor = "green";
        }
        {
          type = "uptime";
          key = "╰─󱑁";
          keyColor = "green";
        }

        "break"

        {
          type = "host";
          keyColor = "blue";
          key = "╭─󰧨";
        }
        {
          type = "cpu";
          key = "├─";
          keyColor = "blue";
        }
        {
          type = "gpu";
          key = "├─";
          keyColor = "blue";
        }
        {
          type = "sound";
          key = "├─";
          format = "{name}";
          keyColor = "blue";
        }
        {
          type = "memory";
          format = "{percentage-bar} {used} / {total}";
          key = "├─";
          keyColor = "blue";
        }
        {
          type = "swap";
          format = "{percentage-bar} {used} / {total}";
          key = "├─";
          keyColor = "blue";
        }
        {
          type = "disk";
          format = "{size-percentage-bar} {name} ({mountpoint}) {size-used} / {size-total} - {filesystem}";
          key = "├─󰋊";
          keyColor = "blue";
        }
        {
          type = "localip";
          key = "╰─";
          keyColor = "blue";
        }

        "break"

        {
          type = "terminal";
          key = "╭─";
          keyColor = "yellow";
        }
        {
          type = "wm";
          key = "├─󰨇";
          keyColor = "yellow";
        }
        {
          type = "de";
          key = "├─󰨇";
          keyColor = "yellow";
        }
        {
          type = "bios";
          key = "├─";
          keyColor = "yellow";
        }
        {
          type = "theme";
          key = "├─󱓓";
          keyColor = "yellow";
        }
        {
          type = "icons";
          key = "├─󱓓";
          keyColor = "yellow";
        }
        {
          type = "cursor";
          key = "╰─󱓓";
          keyColor = "yellow";
        }

        "break"
        "colors"
      ];
    };
  };
}
