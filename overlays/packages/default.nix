{
  pkgs,
  lib,
  ...
} @ args: (lib.mergeAttrsList [
  (import ./custom-pkgs args)
  (import ./proton-pkgs args)
  (import ./fonts.nix args)
  {
    vscode-extensions = lib.recursiveUpdate pkgs.vscode-extensions (import ./vscode-exts.nix args);
  }
])
