{ asa-lib, ... }:
let
  starship = import (asa-lib.root "/common/programs/fastfetch.nix");
in
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = starship.settings.logo;
      display = starship.settings.display;
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
          key = "╰─󰨇";
          keyColor = "yellow";
        }

        "break"
        "colors"
      ];
    };
  };
}

