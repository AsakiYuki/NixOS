{
  lib,
  config,
  ...
}:
lib.mkIf (!config.programs.disable-module.firefox) {
  imports = [./profiles/default];

  files = lib.mkIf config.programs.firefox.enable {
    symlink.".mozilla/firefox" = "${config.home.homeDirectory}/.config/mozilla/firefox";
    mkForce.".config/mozilla/firefox/default/search.json.mozlz4" = true;
  };
}
