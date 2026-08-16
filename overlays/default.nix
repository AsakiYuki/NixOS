{
  inputs,
  lib,
  config,
  ...
}: let
in {
  imports = [
    ./alias-packages.nix
  ];

  nixpkgs.overlays =
    lib.flatten (import ./inputs-overlays.nix inputs)
    ++ (lib.optional (!config.device.de.kdePlasma.enable) inputs.dolphin-overlay.overlays.default);
}
