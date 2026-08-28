{
  lib,
  inputs,
  unstable,
  ...
}: osconfig: users:
lib.mergeAttrsList (
  map (
    {
      name,
      value,
    }: let
      root = value.root or {};
      home = value.home or {};

      nix = value.nix or {};
      trusted-user = nix.is-trusted-user or false;
    in {
      nix.settings.trusted-users = lib.mkIf trusted-user [name];

      users.users.${name} = lib.mergeAttrs {isNormalUser = true;} root;
      home-manager.users.${name} = lib.mergeAttrs home {
        _module.args = lib.mergeAttrs {
          inherit
            inputs
            unstable
            osconfig
            ;
        } (lib.attrByPath ["_module" "args"] {} home);

        imports = lib.concatLists [
          [
            ../options/home
            ../modules/home
          ]

          (with inputs; [
            chaotic.homeModules.default
          ])

          (with inputs; [
            nixvim.homeModules.nixvim
            nixcord.homeModules.nixcord
            niri.homeModules.niri
            agenix.homeManagerModules.default

            cursors.homeModules.default
            proton.homeModules.default
          ])

          (home.imports or [])
        ];

        home = {
          username = name;
          stateVersion = lib.state-version;
        };
      };
    }
  ) (lib.attrsToList users)
)
