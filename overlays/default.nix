{
  inputs,
  lib,
  config,
  ...
}: let
in {
  nixpkgs.overlays =
    lib.flatten (import ./inputs-overlays.nix inputs)
    ++ (lib.optional (!config.device.de.kdePlasma.enable) (import ./dolphin.nix));
}
