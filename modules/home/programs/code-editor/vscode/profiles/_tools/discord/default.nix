{unstable-pkgs, ...}: {
  userSettings = {
    "vscord.app.name" = "VSCodium";
  };

  extensions = with unstable-pkgs.vscode-extensions; [
    leonardssh.vscord
  ];
}
