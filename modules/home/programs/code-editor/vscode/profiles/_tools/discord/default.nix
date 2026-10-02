{
  unstable-pkgs,
  editor-name,
  ...
}: let
  map-name = {
    "vscode" = "VSCode";
    "vscodium" = "VSCodium";
    "antigravity" = "Antigravity";
  };
in {
  userSettings = {
    "vscord.app.name" = map-name.${editor-name};
  };

  extensions = with unstable-pkgs.vscode-extensions; [
    leonardssh.vscord
  ];
}
