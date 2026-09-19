{
  inputs,
  lib,
  config,
  ...
}: let
in {
  nixpkgs.overlays =
    lib.flatten (import ./inputs-overlays.nix inputs)
    ++ (lib.optional (!(lib.attrByPath ["device" "de" "kdePlasma" "enable"] false config)) (import ./dolphin.nix));
}
