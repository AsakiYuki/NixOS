{ lib, pkgs, ... }:
let
  extensions = lib.importJSON ../../assets/chrome.extensions.json;
in
{
  chrome-extensions = lib.mapAttrs (_: extension: {
    inherit (extension) id version;
    crxPath = pkgs.fetchurl extension.src;
  }) extensions;
}
