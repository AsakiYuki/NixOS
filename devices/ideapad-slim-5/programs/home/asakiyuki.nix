{...}: {
  programs = {
    geforce-now.enable = true;

    bash.shellAliases = {
      togglehdr = ''hyprctl eval "ToggleHDR()"'';
    };
  };
}
