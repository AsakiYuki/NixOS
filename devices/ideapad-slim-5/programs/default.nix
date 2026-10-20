{ lib, ... }:
let
  ublockLite = (lib.importJSON (lib.root "/assets/chromium.extensions.json")).ublock-origin-lite;
in
{
  imports = [
    ./home
  ];

  programs.steam.millennium.enable = false;

  programs.chromium = {
    enable = true;
    extraOpts."3rdparty".extensions.${ublockLite.id} = ublockLite.managedSettings;
  };
}
