{
  pkgs,
  config,
  osconfig ? {},
  lib,
  ...
}: {
  config = lib.mkIf (!config.programs.disable-module.dolphin) {
    programs.dolphin = {...}: {
      _module.args = {
        inherit osconfig pkgs;
        hmconfig = config;
      };

      imports = [
        ./services-menu
      ];
    };
  };
}
