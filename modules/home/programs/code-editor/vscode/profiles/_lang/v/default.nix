{unstable-pkgs, ...}: {
  extensions = with unstable-pkgs.vscode-extensions; [
    vosca.vscode-v-analyzer
  ];
}
