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
    };
  };
}
