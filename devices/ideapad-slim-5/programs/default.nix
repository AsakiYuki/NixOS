{ pkgs, ... }:
{
  imports = [
    ./home
  ];

  programs.steam.millennium.enable = false;

  programs.chromium = {
    enable = true;
    extraOpts."3rdparty".extensions = {
      ${pkgs.chrome-extensions.ublock-origin-lite.id} = {
        defaultFiltering = "complete";
        disableFirstRunPage = true;
        showBlockedCount = true;
      };
      ${pkgs.chrome-extensions.tampermonkey.id} = {
        jsonImport = [ ];
      };
      ${pkgs.chrome-extensions.keepassxc-browser.id}.settings = {
        colorTheme = "system";
        autoRetrieveCredentials = true;
        showGettingStartedGuideAlert = false;
      };
      ${pkgs.chrome-extensions.auto-tab-discard.id} = {
        period = 1800;
        number = 20;
        mode = "time-based";
        audio = true;
        paused = true;
        pinned = true;
        form = true;
        online = true;
      };
    };
  };
}
