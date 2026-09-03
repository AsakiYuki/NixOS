{unstable, ...}: {
  extensions = with unstable.vscode-extensions; [
    firefox-devtools.vscode-firefox-debug
    ms-vscode.live-server
  ];
}
