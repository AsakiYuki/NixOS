{
  pkgs,
  lib,
  ...
} @ args: (lib.mergeAttrsList [
  (import ./custom-pkgs args)
  (import ./chrome-extensions.nix args)
  (import ./firefox-addons.nix args)
  (import ./millennium args)
  (import ./proton-pkgs.nix args)
  (import ./fonts.nix args)
  {
    vscode-extensions = lib.recursiveUpdate pkgs.vscode-extensions (import ./vscode-exts.nix args);
  }
])
