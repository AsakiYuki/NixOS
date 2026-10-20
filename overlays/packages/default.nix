{
  pkgs,
  lib,
  sources,
  ...
} @ args:
let
  packageArgs = args // { inherit sources; };
in
(lib.mergeAttrsList [
  (import ./custom-pkgs packageArgs)
  (import ./browser-extensions.nix packageArgs)
  (import ./millennium packageArgs)
  (import ./proton-pkgs.nix packageArgs)
  (import ./fonts.nix packageArgs)
  {
    vscode-extensions = lib.recursiveUpdate pkgs.vscode-extensions (import ./vscode-exts.nix packageArgs);
  }
])
