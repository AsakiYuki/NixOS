{ nixpkgs, ... }@inputs:
let 
  asa-lib = ../libs/default.nix inputs;
  customPkgs = ../pkgs/default.nix inputs;
  unstable = inputs.unstablepkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
  globalSpecialArgs = { inherit inputs asa-lib customPkgs; };
in 
{
  outputs = {
    nixosConfigurations = nixpkgs.lib.nixosSystem {
      lenovo-ideapad-slim-5 = {
        system = "x86_64-linux";
        specialArgs = globalSpecialArgs // { inherit unstable; };
        modules = [
          ../hosts/lenovo-ideapad-slim-5/configuration.nix
          inputs.nixos-hardware.nixosModules.lenovo-ideapad-slim-5
        ];
      };
    };
  };
}