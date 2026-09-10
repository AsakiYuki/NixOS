{
  unstable-pkgs,
  osconfig,
  config,
  pkgs,
  lib,
  ...
}: let
  profiles = globalconfig: (lib.mapAttrs' (name: path: {
      inherit name;
      value = {...}: (globalconfig
        // {
          imports = [./default] ++ path;
          _module.args = {
            inherit osconfig pkgs lib unstable-pkgs;
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
  programs = {
    vscode.profiles = profiles config.programs.vscode.global;
    vscodium.profiles = profiles config.programs.vscodium.global;
  };
}
