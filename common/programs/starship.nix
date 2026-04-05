{
  settings = {
    add_newline = true;
    scan_timeout = 10;

    format = ''
      $os $shell $cmake$java$nodejs$git_branch$character
      $cmd_duration$sudo$directory > '';

    sudo = {
      format = "[$symbol]($style) ";
      symbol = "";
      disabled = false;
    };

    java = {
      format = "[$symbol $version]($style) ";
      symbol = "";
    };

    cmake = {
      format = "[$symbol $version](bold blue) ";
      symbol = "";
    };

    nodejs = {
      format = "[$symbol $version](bold green) ";
      symbol = "󰎙";
    };

    git_branch = {
      format = "[$symbol $branch]($style) ";
      symbol = "";
      style = "red";
      disabled = false;
    };

    directory = {
      format = "[$read_only]($read_only_style)[$path]($style)";
      style = "#2e8be8";
      truncation_length = 2;
      read_only = "󰌾 ";
    };

    character = {
      success_symbol = "[](green)";
      error_symbol = "[](red)";
      disabled = false;
    };

    cmd_duration = {
      min_time = 1;
      format = "[\\[$duration\\]]($style) ";
      style = "#C0C0C0";
      show_milliseconds = true;
    };

    shell = {
      disabled = false;
      bash_indicator = "bash";
      fish_indicator = "fish";
      zsh_indicator = "zsh";
      powershell_indicator = "pwsh";
      format = "[$indicator]($style)";
      style = "white";
    };

    os = {
      format = "[$symbol]($style)";
      disabled = false;
      symbols = {
        Arch = "[󰣇](bold blue)";
        Windows = "[](bold blue)";
        NixOS = "[](bold blue)";
      };
    };
  };
}

