{
  description = "Proton home manager modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = {...}: {
    homeModules.default = import ./home;
    overlays.default = final: prev:
      import ./overlays (let
        pkgs = prev;
        lib = prev.lib;
      in {inherit pkgs lib;});
  };
}
