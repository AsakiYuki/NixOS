{
  lib,
  osconfig,
  ...
}: let
  hexColor = hex: let
    cleanHex = builtins.replaceStrings ["#"] [""] hex;
    r = lib.hexToDec (builtins.substring 0 2 cleanHex);
    g = lib.hexToDec (builtins.substring 2 2 cleanHex);
    b = lib.hexToDec (builtins.substring 4 2 cleanHex);
  in "\\1\\e[38;2;${toString r};${toString g};${toString b}m\\2";

  cfg = osconfig.device.theme.catppuccin;
  colors = lib.catppuccin.${cfg.flavor};
  accent = colors.${cfg.accent};
  accent-2 = colors.${cfg.accent-2};
in {
  programs.readline = {
    enable = true;

    variables = {
      completion-ignore-case = "on";
      show-all-if-ambiguous = "on";
      completion-map-case = "on";
      colored-stats = "on";
      visible-stats = "on";
      mark-symlinked-directories = "on";

      expand-tilde = "on";
      history-preserve-point = "on";
      bell-style = "none";

      editing-mode = "vi";

      show-mode-in-prompt = "on";
      vi-cmd-mode-string = "${hexColor accent-2}[CMD]\\1\\e[0m\\2 ";
      vi-ins-mode-string = "${hexColor accent}[INS]\\1\\e[0m\\2 ";
      horizontal-scroll-mode = "off";
      enable-bracketed-paste = "on";
      skip-completed-text = "on";
      echo-control-characters = "off";
    };

    bindings = {
      "\\e[A" = "history-search-backward";
      "\\e[B" = "history-search-forward";

      "\\e[1;5C" = "forward-word";
      "\\e[1;5D" = "backward-word";

      "\\e[3;5~" = "kill-word";

      "\\e." = "yank-last-arg";
      "\\eu" = "upcase-word";
      "\\el" = "downcase-word";
      "\\ec" = "capitalize-word";
      "\\et" = "transpose-words";
      "\\es" = "\"\\C-a-sudo \\C-e\"";
      "\\eg" = "\"git status\\C-m\"";
      "jk" = "vi-movement-mode";
    };
  };
}
