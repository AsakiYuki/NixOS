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
    lib.flatten [
      inputs.overlays.overlays.default
      inputs.millennium.overlays.default
    ]
    ++ (lib.optional (!config.device.de.kdePlasma.enable) inputs.dolphin-overlay.overlays.default);
}
