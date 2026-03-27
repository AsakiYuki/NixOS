{
    description = "The Asa's nix configuration";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
        unstablepkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        nixcord.url = "github:FlameFlag/nixcord";
        nix-minecraft.url = "github:Infinidoge/nix-minecraft";
        hytale-launcher.url = "github:zarilion/hytale-launcher-nix";
        honkai-railway-grub-theme.url = "github:voidlhf/StarRailGrubThemes";
        
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

    outputs = inputs@{ self, nixpkgs, unstablepkgs, ... }: let 
        unstable = import unstablepkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
        };
    in {
        nixosConfigurations = {
            lenovo-ideapad = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = { inherit inputs unstable; };
                modules = [
                    inputs.home-manager.nixosModules.default
                    inputs.nix-index-database.nixosModules.default
                    ./host/lenovo-ideapad/configuration.nix
                ];
            };

            server = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = { inherit inputs; };
                modules = [
                    inputs.home-manager.nixosModules.default
                    inputs.nix-minecraft.nixosModules.minecraft-servers
                    ./host/home/configuration.nix
                    { nixpkgs.overlays = [ inputs.nix-minecraft.overlay ]; }
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