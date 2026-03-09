    {
        description = "Asa's Nix WSL configuration"; 

        inputs = {
            # Default packages manager
            nixpkgs.url = github:NixOS/nixpkgs/nixos-25.11;
            home-manager.url = github:nix-community/home-manager/release-25.11;

            # WSL
            nixos-wsl.url = "github:nix-community/NixOS-WSL";
            nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
        };

        outputs = inputs@{ self, nixpkgs, home-manager, nixos-wsl, ... }: {
            nixosConfigurations = {
                server = nixpkgs.lib.nixosSystem {
                    system = "x86_64-linux";
                    specialArgs = {
                        inherit inputs home-manager;
                    };
                    modules = [
                        home-manager.nixosModules.default
                        ./devices/server/configuration.nix
                    ];
                };

                wsl = nixpkgs.lib.nixosSystem {
                    system = "x86_64-linux";
                    specialArgs = {
                        inherit inputs nixos-wsl home-manager;
                    };
                    modules = [
                        nixos-wsl.nixosModules.default
                        home-manager.nixosModules.default
                        ./devices/wsl/configuration.nix
                    ];
                };
            };
        };
    }
