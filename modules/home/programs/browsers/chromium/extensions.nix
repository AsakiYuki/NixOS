{ config, lib, pkgs, ... }:
{
  programs.chromium.extensions = lib.mkIf config.programs.chromium.enable (
    with pkgs.chrome-extensions;
    [
      ublock-origin-lite
      tampermonkey
    ]
  );
}
