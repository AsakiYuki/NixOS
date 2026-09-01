{...} @ inputs: [
  (final: prev: (import ../modules/custom/overlays {pkgs = prev;}))
  (final: prev: (import ../modules/custom/proton {
    pkgs = prev;
    lib = prev.lib;
  }))
  inputs.millennium.overlays.default
]
