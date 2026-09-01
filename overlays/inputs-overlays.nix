{...} @ inputs: [
  (_: pkgs: import ./packages (pkgs // {inherit pkgs;}))
  inputs.millennium.overlays.default
]
