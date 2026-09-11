{
  unstable-pkgs,
  isCodium,
  ...
}: {
  userSettings = {
    "vscord.app.name" =
      if isCodium
      then "VSCodium"
      else "VSCode";
  };

  extensions = with unstable-pkgs.vscode-extensions; [
    leonardssh.vscord
  ];
}
