{
  description = "The Asa's nix configurations";

  inputs = {
    # Packages Manager
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nur.url = "github:nix-community/NUR";
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
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    # Security
    agenix.url = "github:ryantm/agenix";
    lanzaboote.url = "github:nix-community/lanzaboote/v1.0.0";

    # Database
    nix-index-database.url = "github:nix-community/nix-index-database";

    # Follows
    nur.inputs.nixpkgs.follows = "nixpkgs";
    millennium.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.inputs.home-manager.follows = "home-manager";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "home-manager";
  };

  outputs = {...} @ inputs: let
    inherit (inputs.nixpkgs) lib self;
    state-version = "26.05";
    root = path: ./. + path;

    args = {
      inherit inputs self state-version lib root;
    };
  in (lib.mergeAttrsList [
    (import ./configs/nixos.nix args)
    (import ./configs/home.nix args)
    (import ./configs/dev.nix args)
  ]);
}
