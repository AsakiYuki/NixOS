{...} @ inputs: let
  importOverlays = path: (_: pkgs: (import path (pkgs // {inherit pkgs;})));
in [
  (importOverlays ./packages)
  inputs.millennium.overlays.default
]
