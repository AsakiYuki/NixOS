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

    overlays.url = "path:./flakes/overlays";
    overlays.inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    cursors.url = "path:./flakes/cursors";
    cursors.inputs.nixpkgs.follows = "nixpkgs";

    proton.url = "path:./flakes/proton";
    proton.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    state-version = "26.05";
    lib = nixpkgs.lib;
  in
    lib.mergeAttrsList [
      (import ./devShell.nix inputs)
      (import ./nixosConfigurations.nix {inherit inputs self state-version lib;})
    ];
}
