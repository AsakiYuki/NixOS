{unstable-pkgs, ...}: {
  extensions = with unstable-pkgs.vscode-extensions; [
    thenuprojectcontributors.vscode-nushell-lang
  ];
}
