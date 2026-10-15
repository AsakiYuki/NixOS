{unstable-pkgs, ...}: {
  extensions = with unstable-pkgs.vscode-extensions; [
    detachhead.basedpyright
    ms-python.python
    ms-python.debugpy
  ];
}
