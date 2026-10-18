{
  pkgs,
  lib,
  ...
}: let
  pluginData = lib.importJSON ../../assets/millennium.plugins.json;

  mkMillenniumPlugin = {
    pname,
    version ? "unstable",
    src,
    meta ? {},
  }:
    pkgs.stdenvNoCC.mkDerivation {
      inherit pname version src;

      dontBuild = true;
      dontConfigure = true;
      dontFixup = true;

      installPhase = ''
        runHook preInstall
        mkdir -p "$out"
        cp -R . "$out/"
        runHook postInstall
      '';

      meta =
        {
          description = "Millennium plugin ${pname}";
          platforms = lib.platforms.linux;
        }
        // meta;
    };

  plugins = lib.mapAttrs (id: plugin:
    mkMillenniumPlugin {
      pname = id;
      inherit (plugin) version;
      src = pkgs.fetchFromGitHub {
        inherit (plugin) owner repo rev;
        sha256 = plugin.hash;
      };
      meta = {
        description = plugin.description;
        homepage = "https://github.com/${plugin.owner}/${plugin.repo}";
      };
    })
  pluginData.plugins;
in {
  millennium-plugin = mkMillenniumPlugin;
  millennium-plugins = plugins;
}
