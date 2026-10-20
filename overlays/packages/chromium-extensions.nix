{ lib, pkgs, ... }:
let
  extensions = lib.importJSON ../../assets/chromium.extensions.json;
in
{
  chromium-extensions = lib.mapAttrs (
    name: extension:
    pkgs.runCommand "${name}-${extension.version}"
      {
        passthru = { inherit (extension) id; };
        meta = extension.meta or { };
      }
      ''
        mkdir -p "$out/share/chromium/extensions"
        install -m 0444 ${pkgs.fetchurl extension.src} "$out/share/chromium/extensions/${extension.id}.crx"
      ''
  ) extensions;
}
