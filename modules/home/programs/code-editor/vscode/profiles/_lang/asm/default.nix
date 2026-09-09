{unstable-pkgs, ...}: {
  extensions = with unstable-pkgs.vscode-extensions; [
    p13xforever.language-x86-64-assembly
  ];
}
