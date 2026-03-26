{
    description = "Asa's Nix configuration (Server & WSL)";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
        unstablepkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        nixcord.url = "github:FlameFlag/nixcord";
        hytale-launcher.url = "github:zarilion/hytale-launcher-nix";
        honkai-railway-grub-theme.url = "github:voidlhf/StarRailGrubThemes";
        
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

    outputs = inputs@{ self, nixpkgs, hytale-launcher, honkai-railway-grub-theme, unstablepkgs, nixcord, ... }: let 
        unstable = import unstablepkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
        };
    in {
        nixosConfigurations = {
            laptop = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = { inherit inputs unstable; };
                modules = [
                    inputs.home-manager.nixosModules.default
                    ./host/laptop/configuration.nix
                ];
            };

            server = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = { inherit inputs; };
                modules = [
                    inputs.home-manager.nixosModules.default
                    ./host/server/configuration.nix
                ];
            };

            wsl = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = { inherit inputs; };
                modules = [
                    inputs.nixos-wsl.nixosModules.default
                    inputs.home-manager.nixosModules.default
                    ./host/wsl/configuration.nix
                ];
            };
        };
    };
}