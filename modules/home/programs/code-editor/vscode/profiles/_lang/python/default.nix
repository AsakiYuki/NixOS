{unstable-pkgs, ...}: {
  extensions = with unstable-pkgs.vscode-extensions; [
    ms-python.vscode-pylance
    ms-python.python
    ms-python.debugpy
  ];
}
