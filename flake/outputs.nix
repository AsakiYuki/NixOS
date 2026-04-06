{ nixpkgs, ... }@inputs:
let 
  asa-lib = ../libs/default.nix inputs;
  unstable = inputs.unstablepkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in 
{
  outputs = {
    nixosConfigurations = {

    };
  };
}