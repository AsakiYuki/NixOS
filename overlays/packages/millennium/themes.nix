{
  pkgs,
  lib,
  ...
}: let
  themeData = lib.importJSON ../../../assets/millennium.json;

  mkMillenniumTheme = {
    pname,
    version,
    src,
    meta ? {},
  }:
    pkgs.stdenvNoCC.mkDerivation {
      inherit pname version src;

      dontBuild = true;

      installPhase = ''
        skinJson=$(find . -type f -name skin.json -print -quit)
        if [ -z "$skinJson" ]; then
          echo "No skin.json found in the Millennium theme source" >&2
          exit 1
        fi

        themeRoot=''${skinJson%/skin.json}
        mkdir -p "$out"
        cp -R "$themeRoot"/. "$out/"
      '';

      meta = {
        description = "Millennium theme ${pname}";
        homepage = "https://steambrew.app/themes";
        platforms = lib.platforms.linux;
      } // meta;
    };

  themes = lib.mapAttrs (id: theme:
    mkMillenniumTheme {
      pname = id;
      inherit (theme) version;
      src = pkgs.fetchFromGitHub {
        inherit (theme) owner repo rev;
        sha256 = theme.hash;
      };
      meta = {
        description = theme.description;
        homepage = "https://github.com/${theme.owner}/${theme.repo}";
      };
    })
  (themeData.themes or {});
in {
  millennium-theme = mkMillenniumTheme;
  millennium-themes = themes;
}
