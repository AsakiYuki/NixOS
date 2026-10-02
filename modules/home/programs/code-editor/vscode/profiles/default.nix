{
  unstable-pkgs,
  osconfig ? {},
  config,
  pkgs,
  lib,
  ...
}: let
  profiles = editor: globalconfig: (lib.mapAttrs' (name: path: {
      inherit name;
      value = {...}: (globalconfig
        // {
          imports = [./default] ++ path;
          _module.args = {
            inherit editor osconfig pkgs lib unstable-pkgs;
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
    vscode.profiles = lib.mkIf (!config.programs.disable-module.vscode) (profiles "vscode" config.programs.vscode.global);
    vscodium.profiles = lib.mkIf (!config.programs.disable-module.vscodium) (profiles "vscodium" config.programs.vscodium.global);
    antigravity.profiles = lib.mkIf (!config.programs.disable-module.vscodium) (profiles "antigravity" config.programs.vscodium.global);
  };
}
