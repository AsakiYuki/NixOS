{unstable, ...}: {
  extensions = with unstable.vscode-extensions; [
    ms-python.vscode-pylance
    ms-python.python
    ms-python.debugpy
  ];
}
