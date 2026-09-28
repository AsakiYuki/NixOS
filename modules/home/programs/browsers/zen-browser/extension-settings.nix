{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.zen-browser = lib.mkIf (!config.programs.disable-module.zen-browser) {
    extension-settings.override = with pkgs.firefox-addons; [
      {
        package = styl-us;
        settings = {
          updateInterval = 24;
          updateOnlyEnabled = true;
          patchCsp = true;
          "editor.linter" = "";
        };
      }
    ];
  };
}
