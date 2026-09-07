{nixpkgs, ...}:
import nixpkgs {
  overlays = [
    (_: pkgs: import ./overlays/packages (pkgs // {inherit pkgs;}))
  ];
}
