{
  buildFirefoxXpiAddon,
  lib,
  ...
}: let
  addons = lib.importJSON ../../assets/firefox.addons.json;
in {
  firefox-addons = lib.mapAttrs (name: {
    id,
    version,
    src,
    meta ? {},
  }:
    buildFirefoxXpiAddon {
      inherit meta version;
      addonid = id;
      fetchurl = src;
    })
  addons;
}
