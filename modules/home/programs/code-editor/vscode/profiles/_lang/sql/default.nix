{unstable-pkgs, ...}: {
  extensions = with unstable-pkgs.vscode-extensions; [
    cweijan.vscode-mysql-client2
  ];
}
