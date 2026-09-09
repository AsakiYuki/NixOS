{unstable-pkgs, ...}: {
  extensions = with unstable-pkgs.vscode-extensions; [
    bmewburn.vscode-intelephense-client
  ];
}
