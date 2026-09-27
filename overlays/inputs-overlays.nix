{...} @ inputs: let
  importOverlays = path: (_: pkgs: (import path (pkgs // {inherit pkgs;})));
in [
  (importOverlays ./helpers)
  (importOverlays ./packages)
  inputs.millennium.overlays.default
  inputs.nur.overlays.default
]
