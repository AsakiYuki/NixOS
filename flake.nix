{
  description = "The Asa's nix configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    agenix.url = "github:ryantm/agenix";
    unstablepkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    iris.url = "github:versenilvis/IRIS";
    niri.url = "github:sodiboo/niri-flake";
    nixcord.url = "github:FlameFlag/nixcord";
    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
    dolphin-overlay.url = "github:asakiyuki/dolphin-overlay";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
    millennium.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote.url = "github:nix-community/lanzaboote/v1.0.0";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    fcitx5-lotus.url = "github:LotusInputMethod/fcitx5-lotus";
    fcitx5-lotus.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    state-version = "26.05";
    root = path: ./. + path;

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
    (nixos {inherit self inputs state-version lib;})
    (devShell inputs)
  ]);
}
