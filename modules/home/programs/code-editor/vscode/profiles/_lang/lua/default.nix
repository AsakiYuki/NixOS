{unstable-pkgs, ...}: {
  extensions = with unstable-pkgs.vscode-extensions; [
    sumneko.lua
  ];
}
