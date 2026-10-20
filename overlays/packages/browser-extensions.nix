{
  lib,
  pkgs,
  sources,
  ...
}:
let
  extensions = sources.extensions;

  buildFirefoxAddon = name: addon:
    pkgs.stdenv.mkDerivation {
      pname = name;
      inherit (addon) version;
      src = pkgs.fetchurl addon.src;
      meta = { addonid = addon.id; } // (addon.meta or { });

      preferLocalBuild = true;
      allowSubstitutes = false;

      buildCommand = ''
        addonDirectory="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$addonDirectory"
        install -m 0644 "$src" "$addonDirectory/${addon.id}.xpi"
      '';
    };

  firefoxAddons = lib.mapAttrs buildFirefoxAddon extensions.firefox;

  chromeExtensions = lib.mapAttrs (_: extension: {
    inherit (extension) id version;
    crxPath = pkgs.fetchurl extension.src;
  }) extensions.chrome;
in
{
  firefox-addons = firefoxAddons;
  chrome-extensions = chromeExtensions;
}
