{pkgs, ...}: {
  home.packages = [
    pkgs.opennow
  ];

  programs = {
    bash.shellAliases = {
      togglehdr = ''hyprctl eval "ToggleHDR()"'';
    };
  };
}
