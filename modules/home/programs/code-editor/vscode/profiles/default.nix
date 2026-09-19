{
  unstable-pkgs,
  osconfig ? {},
  config,
  pkgs,
  lib,
  ...
}: let
  profiles = is-codium: globalconfig: (lib.mapAttrs' (name: path: {
      inherit name;
      value = {...}: (globalconfig
        // {
          imports = [./default] ++ path;
          _module.args = {
            inherit is-codium osconfig pkgs lib unstable-pkgs;
            hmconfig = config;
          };
        });
    }) {
      default = [];
      node = [./node];
      mcbe = [./minecraft/bedrock];
      mcje = [./minecraft/java];
      nix = [./nix];
      gd = [./geometry-dash];
    });
in {
  config.programs = {
    vscode.profiles = profiles false config.programs.vscode.global;
    vscodium.profiles = profiles true config.programs.vscodium.global;
  };
}
