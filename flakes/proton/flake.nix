{
  description = "Proton home manager modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = {...}: {
    homeModules.default = import ./home;
    overlays.default = import ./overlays;
  };
}
