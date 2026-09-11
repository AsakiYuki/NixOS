{
  unstable-pkgs,
  osconfig,
  config,
  pkgs,
  lib,
  ...
}: let
  profiles = isCodium: globalconfig: (lib.mapAttrs' (name: path: {
      inherit name;
      value = {...}: (globalconfig
        // {
          imports = [./default] ++ path;
          _module.args = {
            inherit isCodium osconfig pkgs lib unstable-pkgs;
            hmconfig = config;
          };
        });
    }) {
      default = [];
      mcbe = [./minecraft/bedrock];
      mcje = [./minecraft/java];
      nix = [./nix];
      gd = [];
    });
in {
  config.programs = {
    vscode.profiles = profiles false config.programs.vscode.global;
    vscodium.profiles = profiles true config.programs.vscodium.global;
  };
}
