{
  description = "The Asa's nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    unstablepkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixcord.url = "github:FlameFlag/nixcord";
    hytale-launcher.url = "github:zarilion/hytale-launcher-nix";
    honkai-railway-grub-theme.url = "github:voidlhf/StarRailGrubThemes/4a84e576bb544afbdfc76dbe40ffc50a5c2b16de";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      unstablepkgs,
      ...
    }:
    let
      asa-lib = import ./libs/_lib.nix;
      unstable = import unstablepkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        lenovo-ideapad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit asa-lib inputs unstable; };
          modules = [
            ./host/lenovo-ideapad/configuration.nix
            inputs.home-manager.nixosModules.default
            inputs.nix-index-database.nixosModules.default
          ];
        };

        server = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit asa-lib inputs; };
          modules = [
            ./host/home/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };

        wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit asa-lib inputs; };
          modules = [
            ./host/wsl/configuration.nix
            inputs.nixos-wsl.nixosModules.default
            inputs.home-manager.nixosModules.default
          ];
        };
      };
    };
}
