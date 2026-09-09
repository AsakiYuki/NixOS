{unstable-pkgs, ...}: {
  extensions = with unstable-pkgs.vscode-extensions; [
    joshuapoehls.json-escaper
  ];
}
