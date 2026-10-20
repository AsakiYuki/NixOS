{sources, ...} @ inputs: let
  importOverlays = path: (_: pkgs: (import path (pkgs // { inherit pkgs sources; })));
in [
  (importOverlays ./packages)
  inputs.millennium.overlays.default
]
