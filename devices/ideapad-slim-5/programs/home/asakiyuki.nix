{unstable-pkgs, ...}: {
  programs = {
    bash.shellAliases = {
      togglehdr = ''hyprctl eval "ToggleHDR()"'';
    };

    vscodium.global.extensions = with unstable-pkgs.vscode-extensions; [
      wakatime.vscode-wakatime
    ];
  };
}
