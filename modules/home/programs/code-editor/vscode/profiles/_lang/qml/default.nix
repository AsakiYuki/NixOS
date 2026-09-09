{unstable-pkgs, ...}: {
  extensions = with unstable-pkgs.vscode-extensions; [
    theqtcompany.qt-qml
    bbenoist.qml
  ];
}
