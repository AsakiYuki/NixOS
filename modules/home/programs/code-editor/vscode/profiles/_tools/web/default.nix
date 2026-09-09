{unstable-pkgs, ...}: {
  extensions = with unstable-pkgs.vscode-extensions; [
    firefox-devtools.vscode-firefox-debug
    ms-vscode.live-server
  ];
}
