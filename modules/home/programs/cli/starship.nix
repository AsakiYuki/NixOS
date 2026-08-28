{
  osconfig,
  lib,
  ...
}: let
  cfg = osconfig.device.theme.catppuccin;
  colors = lib.catppuccin.${cfg.flavor};
  accent = colors.${cfg.accent};
in {
  programs.starship = {
    settings = {
      add_newline = true;
      scan_timeout = 10;

      format = ''
        $os $shell $cmake$java$nodejs$git_branch$character
        $cmd_duration$sudo$directory > '';

      sudo = {
        format = "[$symbol](bold fg:${accent}) ";
        symbol = "";
        disabled = false;
      };

      java = {
        format = "[$symbol $version](bold fg:${colors.red}) ";
        symbol = "";
      };

      cmake = {
        format = "[$symbol $version](bold fg:${colors.blue}) ";
        symbol = "";
      };

      nodejs = {
        format = "[$symbol $version](bold fg:${colors.green}) ";
        symbol = "󰎙";
      };

      git_branch = {
        format = "[$symbol $branch](bold fg:${colors.red}) ";
        symbol = "";
        disabled = false;
      };

      directory = {
        format = "[$read_only]($read_only_style)[$path]($style)";
        style = accent;
        truncation_length = 2;
        read_only = "󰌾 ";
      };

      character = {
        success_symbol = "[](fg:${colors.green})";
        error_symbol = "[](fg:${colors.red})";
        disabled = false;
      };

      cmd_duration = {
        min_time = 1;
        format = "[\\[$duration\\]]($style) ";
        style = colors.subtext1;
        show_milliseconds = true;
      };

      shell = {
        disabled = false;
        bash_indicator = "bash";
        fish_indicator = "fish";
        zsh_indicator = "zsh";
        powershell_indicator = "pwsh";
        format = "[$indicator]($style)";
        style = colors.text;
      };

      os = {
        format = "[$symbol]($style)";
        disabled = false;
        symbols = {
          Arch = "[󰣇](bold fg:${accent})";
          Windows = "[](bold fg:${accent})";
          NixOS = "[](bold fg:${accent})";
          Macos = "[](bold fg:${accent})";
          Android = "[](bold fg:${accent})";
        };
      };
    };
  };
}
