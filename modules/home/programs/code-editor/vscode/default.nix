{
  unstable-pkgs,
  lib,
  config,
  ...
}: let
  argvSettings = {};
in {
  imports = [./profiles];

  programs.vscode = lib.mkIf (!config.programs.disable-module.vscode) {
    inherit argvSettings;
    package = unstable-pkgs.vscode;
  };

  programs.vscodium = lib.mkIf (!config.programs.disable-module.vscodium) {
    inherit argvSettings;
    package = unstable-pkgs.vscodium;
  };
}
