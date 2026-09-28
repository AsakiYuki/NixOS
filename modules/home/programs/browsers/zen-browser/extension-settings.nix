{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.zen-browser = lib.mkIf (!config.programs.disable-module.zen-browser) {
    extension-settings.override = with pkgs.firefox-addons; [
      {
        package = ublock-origin;
        settings = {
          filterLists = [
            "user-filters"
            "ublock-filters"
            "ublock-badware"
            "ublock-privacy"
            "ublock-unbreak"
            "adguard-spyware-url"
          ];
        };
      }
    ];
  };
}
