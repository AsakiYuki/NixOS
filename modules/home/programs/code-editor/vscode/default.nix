{unstable, ...}: let
  argvSettings = {};
in {
  imports = [./profiles];

  programs.vscode = {
    inherit argvSettings;
    package = unstable.vscode;
  };

  programs.vscodium = {
    inherit argvSettings;
    package = unstable.vscodium;
  };
}
