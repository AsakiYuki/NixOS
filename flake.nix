{
  description = "The Asa's nix configurations";

  inputs = {
    # Packages Manager
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # Modules
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixcord.url = "github:FlameFlag/nixcord";
    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";

    # Security
    agenix.url = "github:ryantm/agenix";
    lanzaboote.url = "github:nix-community/lanzaboote/v1.0.0";

    # Database
    nix-index-database.url = "github:nix-community/nix-index-database";

    # Follows
    millennium.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {...} @ inputs: let
    inherit (inputs.nixpkgs) lib self;
    state-version = "26.05";
    root = path: ./. + path;

    home-manager = {inputs, ...}@args: {
      homeConfigurations."asakiyuki@Macbook-Air-M5" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages."aarch64-darwin";
        modules = [
          (root "/host/macos")
        ];
      };
    };

    nixos = {inputs, ...} @ args: (import ./helpers/nixosConfigurations.nix args {
      ideapad-slim-5 = {
        modules = [
          inputs.nixos-hardware.nixosModules.lenovo-ideapad-slim-5
          inputs.lanzaboote.nixosModules.lanzaboote
          (root "/devices/ideapad-slim-5/configuration.nix")
        ];
      };
      msi-sayu = {
        modules = [
          (root "/devices/msi-sayu/configuration.nix")
        ];
      };
      home-server = {
        modules = [
          (root "/devices/home-server/configuration.nix")
        ];
      };
      wsl = {
        modules = [
          inputs.nixos-wsl.nixosModules.default
          (root "/devices/wsl/configuration.nix")
        ];
      };
    });

    devShell = {...} @ args: (import ./helpers/devShells.nix args {
      default = {
        overlays = import ./overlays/inputs-overlays.nix inputs;
        shell = {pkgs, ...}: {
          buildInputs = with pkgs; [
            bun
            vsce
          ];

          shellHook = ''
            echo "Welcome to NixOS DevShell!"

            if [ -e .env ]; then
              source .env
            fi

            export NIX_CONFIG="access-tokens = github.com=''${GH_TOKEN}"

            alias repl="nix repl ."
            alias agenix="./agenix.sh"
          '';
        };
      };
    });
  in (lib.mergeAttrsList [
    (nixos {
      inherit inputs self state-version lib;
    })
    (devShell inputs)
    (home-manager {
      inherit inputs self state-version lib;
    })
  ]);
}
