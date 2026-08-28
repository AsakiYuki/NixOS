{
  osconfig,
  lib,
  ...
}: let
  cfg = osconfig.device.theme.catppuccin;
  colors = lib.catppuccin.${cfg.flavor};
  accent = colors.${cfg.accent};
  accent-2 = colors.${cfg.accent-2};
in {
  programs.fastfetch = {
    settings = {
      logo = {
        padding.top = 1;
        color = {
          "1" = accent;
          "2" = accent-2;
          "3" = accent;
          "4" = accent-2;
          "5" = accent;
          "6" = accent-2;
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
            border = accent;
            elapsed = accent;
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
          outputColor = accent;
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
          keyColor = accent;
        }
        {
          type = "kernel";
          key = "├─󰌽";
          keyColor = accent;
        }
        {
          type = "shell";
          key = "├─";
          keyColor = accent;
        }
        {
          type = "packages";
          key = "├─󰆧";
          keyColor = accent;
        }
        {
          type = "uptime";
          key = "╰─󱑁";
          keyColor = accent;
        }

        "break"

        {
          type = "host";
          keyColor = accent-2;
          key = "╭─󰧨";
        }
        {
          type = "cpu";
          key = "├─";
          keyColor = accent-2;
        }
        {
          type = "gpu";
          key = "├─";
          keyColor = accent-2;
        }
        {
          type = "sound";
          key = "├─";
          format = "{name}";
          keyColor = accent-2;
        }
        {
          type = "memory";
          format = "{percentage-bar} {used} / {total}";
          key = "├─";
          keyColor = accent-2;
        }
        {
          type = "swap";
          format = "{percentage-bar} {used} / {total}";
          key = "├─";
          keyColor = accent-2;
        }
        {
          type = "disk";
          format = "{size-percentage-bar} {name} ({mountpoint}) {size-used} / {size-total} - {filesystem}";
          key = "├─󰋊";
          keyColor = accent-2;
        }
        {
          type = "localip";
          key = "╰─";
          keyColor = accent-2;
        }

        "break"

        {
          type = "terminal";
          key = "╭─";
          keyColor = accent;
        }
        {
          type = "wm";
          key = "├─󰨇";
          keyColor = accent;
        }
        {
          type = "de";
          key = "├─󰨇";
          keyColor = accent;
        }
        {
          type = "bios";
          key = "├─";
          keyColor = accent;
        }
        {
          type = "theme";
          key = "├─󱓓";
          keyColor = accent;
        }
        {
          type = "icons";
          key = "├─󱓓";
          keyColor = accent;
        }
        {
          type = "cursor";
          key = "╰─󱓓";
          keyColor = accent;
        }

        "break"
        "colors"
      ];
    };
  };
}
