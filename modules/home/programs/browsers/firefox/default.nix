{
  lib,
  config,
  pkgs,
  ...
}: {
  files = lib.mkIf config.programs.firefox.enable {
    symlink.".mozilla/firefox" = "${config.home.homeDirectory}/.config/mozilla/firefox";
    mkForce.".config/mozilla/firefox/default/search.json.mozlz4" = true;
  };

  programs.firefox.profiles.default = {...}: {
    _module.args = {inherit pkgs;};
    imports = [./search.nix ./settings.nix];

    userChrome = lib.readRootFile "/assets/programs/firefox/userChrome.css";
    userContent = lib.readRootFile "/assets/programs/firefox/userContent.css";
  };
}
