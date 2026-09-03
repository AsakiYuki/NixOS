{unstable, ...}: {
  userSettings = {
    "vscord.app.name" = "VSCodium";
  };

  extensions = with unstable.vscode-extensions; [
    leonardssh.vscord
  ];
}
