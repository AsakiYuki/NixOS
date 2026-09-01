{
  inputs,
  self,
  state-version,
  lib,
}: let
  nixosModules = name: inputs.${name}.nixosModules.default;

  defaultModules = [
    inputs.chaotic.nixosModules.default
    (nixosModules "nix-index-database")
    (nixosModules "home-manager")
    (nixosModules "agenix")
  ];
in
  cfg: {
    nixosConfigurations = lib.mapAttrs (name: hostCfg: let
      sys = hostCfg.system or "x86_64-linux";

      unstable = import inputs.unstablepkgs {
        localSystem = sys;
        config.allowUnfree = true;
        overlays = [
          (_: pkgs: import ../overlays/packages (pkgs // {inherit pkgs;}))
        ];
      };

      _lib = lib.extend (final: _:
        (import ../helpers {
          inherit inputs self unstable;
          lib = final;
        })
        // {
          flake-name = name;
          inherit state-version;
        });
    in
      _lib.nixosSystem {
        system = sys;

        specialArgs =
          {
            inherit self inputs unstable;
            lib = _lib;
          }
          // (hostCfg.specialArgs or {});

        modules =
          (hostCfg.modules or [])
          ++ defaultModules
          ++ [
            (_lib.root "/modules/nixos-default.nix")
            (_lib.root "/overlays")
            (_lib.root "/modules/system")
            (_lib.root "/options/system")
          ];
      })
    cfg;
  }
