{
  unstable-pkgs,
  editor,
  ...
}: let
  name-map = {
    "vscode" = "VSCode";
    "vscodium" = "VSCodium";
    "antigravity" = "Antigravity";
  };
in {
  userSettings = {
    "vscord.app.name" = name-map.${editor};
  };

  extensions = with unstable-pkgs.vscode-extensions; [
    leonardssh.vscord
  ];
}
