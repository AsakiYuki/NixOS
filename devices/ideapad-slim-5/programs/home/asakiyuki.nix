{...}: {
  programs = {
    bash.shellAliases = {
      togglehdr = ''hyprctl eval "ToggleHDR()"'';
    };
  };
}
