{
  unstable-pkgs,
  is-codium,
  ...
}: {
  userSettings = {
    "vscord.app.name" =
      if is-codium
      then "VSCodium"
      else "VSCode";
  };

  extensions = with unstable-pkgs.vscode-extensions; [
    leonardssh.vscord
  ];
}
