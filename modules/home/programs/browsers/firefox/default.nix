{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.firefox;
in
{
  config = lib.mkIf (!config.programs.disable-module.firefox) {
    programs.firefox.profiles.default = { ... }: {
      _module.args = { inherit pkgs; };
      imports = [
        ./shared/search.nix
        ./shared/settings.nix
      ];

      extensions.packages = import ./shared/extensions.nix { inherit pkgs; };

      userChrome = lib.readRootFile "/assets/programs/firefox/userChrome.css";
      userContent = lib.readRootFile "/assets/programs/firefox/userContent.css";
    };

    files = lib.mkIf cfg.enable {
      symlink.".mozilla/firefox" = "${config.home.homeDirectory}/.config/mozilla/firefox";
      mkForce.".config/mozilla/firefox/default/search.json.mozlz4" = true;
    };
  };
}
