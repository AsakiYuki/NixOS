{unstable-pkgs, ...}: let
  argvSettings = {};
in {
  imports = [./profiles];

  programs.vscode = {
    inherit argvSettings;
    package = unstable-pkgs.vscode;
  };

  programs.vscodium = {
    inherit argvSettings;
    package = unstable-pkgs.vscodium;
  };
}
