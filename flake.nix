{
    description = "Asa's Nix configuration (Server & WSL)";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
        
        home-manager = {
            url = "github:nix-community/home-manager/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixos-wsl = {
            url = "github:nix-community/NixOS-WSL";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{ self, nixpkgs, ... }: {
        nixosConfigurations = {
            laptop = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = { inherit inputs; };
                modules = [
                    inputs.home-manager.nixosModules.default
                    ./devices/laptop/configuration.nix
                ];
            };

            server = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = { inherit inputs; };
                modules = [
                    inputs.home-manager.nixosModules.default
                    ./devices/server/configuration.nix
                ];
            };

            wsl = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = { inherit inputs; };
                modules = [
                    inputs.nixos-wsl.nixosModules.default
                    inputs.home-manager.nixosModules.default
                    ./devices/wsl/configuration.nix
                ];
            };
        };
    };
}