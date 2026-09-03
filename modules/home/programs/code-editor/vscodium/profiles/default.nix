{
  osconfig,
  config,
  pkgs,
  lib,
  unstable,
  ...
}: let
  mkProfile = path: {...}: {
    imports = [path];
    _module.args = {
      inherit osconfig pkgs lib unstable;
      hmconfig = config;
    };
  };
in {
  programs.vscodium.profiles = {
    default = mkProfile ./default;
  };
}
