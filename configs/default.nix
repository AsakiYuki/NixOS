{
  nixpkgs,
  self,
  ...
} @ inputs: let
  state-version = "26.05";
  lib = nixpkgs.lib;
in
  lib.mergeAttrsList [
    (import ./nixos.nix {inherit inputs self state-version lib;})
    (import ./dev-shell.nix inputs)
    (import ./nix-on-droid.nix inputs)
  ]
