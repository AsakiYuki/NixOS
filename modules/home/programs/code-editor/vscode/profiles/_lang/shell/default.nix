{unstable-pkgs, ...}: {
  extensions = with unstable-pkgs.vscode-extensions; [
    foxundermoon.shell-format
    mads-hartmann.bash-ide-vscode
  ];
}
