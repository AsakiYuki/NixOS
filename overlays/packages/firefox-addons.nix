{
  lib,
  pkgs,
  ...
}: let
  buildFirefoxXpiAddon = {
    pname,
    version,
    meta,
    fetchurl,
    addonid,
    ...
  }: (pkgs.stdenv.mkDerivation {
    inherit meta;

    name = "${pname}-${version}";
    src = pkgs.fetchurl fetchurl;

    preferLocalBuild = true;
    allowSubstitutes = false;

    buildCommand = ''
      dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
      mkdir -p "$dst"
      install -v -m644 "$src" "$dst/${addonid}.xpi"
    '';
  });

  addons = lib.importJSON ../../assets/firefox.addons.json;
in {
  firefox-addons = lib.mapAttrs (pname: {
    id,
    version,
    src,
    meta ? {},
  }:
    buildFirefoxXpiAddon {
      inherit pname meta version;
      addonid = id;
      fetchurl = src;
    })
  addons;
}
