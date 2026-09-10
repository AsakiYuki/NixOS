{...} @ inputs: [
  (_: pkgs: let
    get-arch = archMap: appName:
      archMap.${
        pkgs.stdenv.system
      } or (throw
        "Unsupported system for ${appName}: ${pkgs.stdenv.system}");
  in (import ./packages (pkgs // {inherit pkgs get-arch;})))
  inputs.millennium.overlays.default
]
