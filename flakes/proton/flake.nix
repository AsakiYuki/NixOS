{
  description = "Proton home manager modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = {nixpkgs, ...}: let
    lib = nixpkgs.lib;
    proton = lib.importJSON ../../assets/proton.json;
  in {
    homeModules.default = import ./homeModules.nix;
    overlays.default = final: prev:
      import ./overlays.nix (let
        pkgs = prev;
        lib = prev.lib;
      in {inherit pkgs lib proton;});
  };
}
