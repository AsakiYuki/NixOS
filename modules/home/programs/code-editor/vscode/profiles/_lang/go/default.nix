{unstable-pkgs, ...}: {
  extensions = with unstable-pkgs.vscode-extensions; [
    golang.go
  ];
}
