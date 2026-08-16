{
  inputs,
  self,
  state-version,
  lib,
}: let
  nixosModules = name: inputs.${name}.nixosModules.default;
in
  cfg: {
    nixosConfigurations = lib.mergeAttrsList (
      map (
        {
          name,
          value,
        }: let
          sys = value.system or "x86_64-linux";
          unstable = import inputs.unstablepkgs {
            localSystem = sys;
            config.allowUnfree = true;
          };
          _lib = lib.extend (
            final: prev:
              lib.mergeAttrs (import ../helpers {
                inherit inputs self unstable;
                lib = final;
              })
              {
                flake-name = name;
                state-version = state-version;
              }
          );
        in {
          "${name}" = _lib.nixosSystem {
            system = sys;

            specialArgs = _lib.mergeAttrs {
              inherit self inputs unstable;
              lib = _lib;
            } (value.specialArgs or {});

            modules =
              (value.modules or [])
              ++ (_lib.concatLists [
                (with inputs; [
                  chaotic.nixosModules.default
                ])

                [
                  (nixosModules "nix-index-database")
                  (nixosModules "home-manager")
                  (nixosModules "agenix")
                  (_lib.root "/modules/nixos-default.nix")
                  (_lib.root "/overlays")
                  (_lib.root "/modules/system")
                  (_lib.root "/options/system")
                ]
              ]);
          };
        }
      ) (lib.attrsToList cfg)
    );
  }
