{
  pkgs,
  lib,
  sources,
  ...
}:
let
  themeData = sources.extensions.millennium;

  mkMillenniumTheme =
    {
      pname,
      version,
      src,
      buildCommand ? null,
      depsHash ? null,
      meta ? { },
    }:
    let
      dependencies =
        if buildCommand == null then
          null
        else
          pkgs.stdenvNoCC.mkDerivation {
            pname = "${pname}-node-modules";
            inherit version src;

            nativeBuildInputs = [
              pkgs.nodejs
              pkgs.cacert
              pkgs.jq
            ];
            dontFixup = true;

            env = {
              NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
              NODE_EXTRA_CA_CERTS = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
              npm_config_cafile = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
            };

            outputHashMode = "recursive";
            outputHashAlgo = "sha256";
            outputHash = depsHash;

            buildPhase = ''
              export HOME="$TMPDIR/home"
              export npm_config_cache="$TMPDIR/npm-cache"
              mkdir -p "$HOME" "$npm_config_cache"
              npm install --ignore-scripts --no-audit --no-fund
            '';

            installPhase = ''
              mkdir -p "$out"
              cp -R node_modules "$out/"
            '';
          };
    in
    pkgs.stdenvNoCC.mkDerivation {
      inherit pname version src;

      nativeBuildInputs = [ pkgs.nodejs ];

      patchPhase = lib.optionalString (buildCommand != null) ''
        if [ -f scripts/build ]; then
          substituteInPlace scripts/build \
            --replace-fail 'bunx postcss' '${pkgs.nodejs}/bin/node ${dependencies}/node_modules/postcss-cli/index.js'
        fi
      '';

      buildPhase = lib.optionalString (buildCommand != null) ''
        cp -R ${dependencies}/node_modules ./node_modules
        chmod -R u+w ./node_modules
        patchShebangs node_modules
        export PATH="$PATH:$PWD/node_modules/.bin"
        if [ -e node_modules/.bin/millennium-ttc ]; then
          rm node_modules/.bin/millennium-ttc
          printf '%s\n' \
            '#!${pkgs.runtimeShell}' \
            'exec ${pkgs.nodejs}/bin/node ${dependencies}/node_modules/@steambrew/ttc/dist/index.js "$@" --no-update' \
            > node_modules/.bin/millennium-ttc
          chmod +x node_modules/.bin/millennium-ttc
        fi
        ${buildCommand}
      '';

      installPhase = ''
        rm -rf node_modules
        skinJson=$(find . -type f -name skin.json -print -quit)
        if [ -z "$skinJson" ]; then
          echo "No skin.json found in the Millennium theme source" >&2
          exit 1
        fi

        themeRoot=''${skinJson%/skin.json}
        mkdir -p "$out"
        cp -R "$themeRoot"/. "$out/"
      '';

      passthru = { inherit dependencies; };

      meta = {
        description = "Millennium theme ${pname}";
        homepage = "https://steambrew.app/themes";
        platforms = lib.platforms.linux;
      }
      // meta;
    };

  nixAttrName = id: lib.replaceStrings [ "." ] [ "_" ] id;
  themeIds = lib.attrNames (themeData.themes or { });
  nixThemeIds = map nixAttrName themeIds;
  hasThemeIdCollisions = builtins.length nixThemeIds != builtins.length (lib.unique nixThemeIds);

  themes =
    if hasThemeIdCollisions then
      throw "Millennium theme IDs collide after replacing dots with underscores"
    else
      lib.mapAttrs' (
        id: theme:
        lib.nameValuePair (nixAttrName id) (mkMillenniumTheme {
          pname = id;
          inherit (theme) version;
          buildCommand = theme.buildCommand or null;
          depsHash = theme.depsHash or null;
          src = pkgs.fetchFromGitHub {
            inherit (theme) owner repo rev;
            sha256 = theme.hash;
          };
          meta = {
            description = theme.description;
            homepage = "https://github.com/${theme.owner}/${theme.repo}";
          };
        })
      ) (themeData.themes or { });
in
{
  millennium-theme = mkMillenniumTheme;
  millennium-themes = themes;
}
