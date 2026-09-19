{
  inputs,
  self,
  state-version,
  lib,
  ...
}: cfg: let
  nixosModules = name: inputs.${name}.nixosModules.default;

  defaultModules = [
    inputs.chaotic.nixosModules.default
    (nixosModules "nix-index-database")
    (nixosModules "home-manager")
    (nixosModules "agenix")
  ];
in {
  nixosConfigurations = lib.mapAttrs (name: hostCfg: let
    sys = hostCfg.system or "x86_64-linux";

    unstable-pkgs = import inputs.nixos-unstable {
      localSystem = sys;
      config.allowUnfree = true;
      overlays = [
        (_: pkgs: import ../overlays/packages (pkgs // {inherit pkgs;}))
      ];
    };

    _lib = lib.extend (final: _:
      (import ../helpers {
        inherit inputs self unstable-pkgs;
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
          inherit self inputs unstable-pkgs;
          lib = _lib;
          is-home-configurations = false;
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
