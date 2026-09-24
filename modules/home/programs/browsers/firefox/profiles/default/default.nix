{
  pkgs,
  lib,
  ...
}: {
  programs.firefox.profiles.default = {...}: {
    _module.args = {inherit pkgs;};
    imports = [./search.nix ./settings.nix];

    userChrome = lib.readRootFile "/assets/programs/firefox/userChrome.css";
    userContent = lib.readRootFile "/assets/programs/firefox/userContent.css";
  };
}
