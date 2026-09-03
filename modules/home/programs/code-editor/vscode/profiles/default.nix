{
  unstable,
  osconfig,
  config,
  pkgs,
  lib,
  ...
}: let
  mkProfile = path: {...}: {
    imports = [./default] ++ path;
    _module.args = {
      inherit osconfig pkgs lib unstable;
      hmconfig = config;
    };
  };
in {
  programs = rec {
    vscode.profiles = {
      default = mkProfile [];
      mcbe = mkProfile [./minecraft/bedrock];
      mcje = mkProfile [./minecraft/java];
      nix = mkProfile [./nix];
      gd = mkProfile [./geometry-dash];
    };

    vscodium = vscode;
  };
}
