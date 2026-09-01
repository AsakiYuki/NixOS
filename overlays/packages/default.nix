{
  pkgs,
  lib,
  ...
} @ args: (lib.mergeAttrsList [
  (import ./custom-pkgs args)
  (import ./proton-pkgs args)
  {
    vscode-extensions = lib.recursiveUpdate pkgs.vscode-extensions (import ./vscode-exts.nix args);
  }
])
