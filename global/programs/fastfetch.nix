{ ... }:
{
    settings = {
        logo = {
            padding.top = 1;
            color = {
                "1" = "#89b4fa";
                "2" = "#cdd6f4";
                "3" = "#89b4fa";
                "4" = "#cdd6f4";
                "5" = "#89b4fa";
                "6" = "#cdd6f4";
            };
        };

        display = {
            color = {
                title = "#cdd6f4";
                output = "#cdd6f4";
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
                key = "├─󱓓";
                keyColor = "yellow";
            }
            {
                type = "de";
                key = "╰─󰨇";
                keyColor = "yellow";
            }

            "break"
            "colors"
        ];
    };
}
