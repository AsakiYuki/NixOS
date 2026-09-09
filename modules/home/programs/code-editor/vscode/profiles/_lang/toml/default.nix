{unstable-pkgs, ...}: {
  extensions = with unstable-pkgs.vscode-extensions; [
    tamasfe.even-better-toml
  ];
}
