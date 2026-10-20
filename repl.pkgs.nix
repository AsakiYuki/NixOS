{nixpkgs, ...}:
let
  source-data = builtins.fromJSON (builtins.readFile ./assets/sources.json);
in
import nixpkgs {
  overlays = [
    (_: pkgs: import ./overlays/packages (pkgs // { inherit pkgs; sources = source-data; }))
  ];
}
