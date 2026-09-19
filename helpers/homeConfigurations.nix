{
  lib,
  inputs,
  self,
  state-version,
  ...
} @ args: hosts: {
  homeConfigurations = args.lib.mapAttrs (host: hostCfg: let
    inherit (hostCfg) pkgs modules;

    system = pkgs.stdenv.hostPlatform.system;

    unstable-pkgs = import inputs.nixos-unstable {
      localSystem = system;
      config.allowUnfree = true;
      overlays = [
        (_: p: import ../overlays/packages p)
      ];
    };

    customLib = lib.extend (
      final: _:
        (import ../helpers (args
          // {
            inherit unstable-pkgs;
            lib = final;
          }))
        // {
          flake-name = host;
        }
    );

    defaultModules =
      [
        ../options/home
        ../modules/home
        ../modules/home-default.nix
        ../overlays
        inputs.nixvim.homeModules.nixvim
        inputs.nixcord.homeModules.nixcord
        inputs.agenix.homeManagerModules.default
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        inputs.chaotic.homeModules.default
      ];
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      lib = customLib;
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.allowUnfreePredicate = _: true;
      };
      extraSpecialArgs = {
        inherit self inputs unstable-pkgs state-version;
        flake-name = host;
        is-home-configurations = true;
        osconfig = {};
      };
      modules = defaultModules ++ modules;
    })
  hosts;
}
