{
  pkgs,
  lib,
  ...
}: let
  pluginData = lib.importJSON ../../assets/millennium.json;

  mkMillenniumPlugin = {
    pname,
    version ? "unstable",
    src,
    packageManager,
    depsHash,
    meta ? {},
  }: let
    packageManagerPackage =
      {
        npm = [];
        pnpm = [pkgs.pnpm_10_latest];
        bun = [pkgs.bun];
      }.${
        packageManager
      } or (throw "Unsupported Millennium plugin package manager: ${packageManager}");

    dependencies = pkgs.stdenvNoCC.mkDerivation {
      pname = "${pname}-node-modules";
      inherit version src;

      nativeBuildInputs = [pkgs.nodejs pkgs.cacert] ++ packageManagerPackage;
      dontFixup = true;

      env = {
        NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
        NODE_EXTRA_CA_CERTS = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
        npm_config_cafile = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
        pnpm_config_manage_package_manager_versions = "false";
      };

      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = depsHash;

      buildPhase = ''
        export HOME="$TMPDIR/home"
        export npm_config_cache="$TMPDIR/npm-cache"
        mkdir -p "$HOME" "$npm_config_cache"
        ${
          if packageManager == "pnpm"
          then ''
            ${pkgs.jq}/bin/jq 'del(.packageManager)' package.json > package.json.tmp
            mv package.json.tmp package.json
            pnpm --config.manage-package-manager-versions=false install --frozen-lockfile --ignore-scripts
          ''
          else if packageManager == "bun"
          then "bun install --frozen-lockfile --ignore-scripts --no-progress"
          else "npm install --ignore-scripts --no-audit --no-fund"
        }
      '';

      installPhase = ''
        mkdir -p "$out"
        cp -R node_modules "$out/"
      '';
    };

    plugin = pkgs.stdenvNoCC.mkDerivation {
      inherit pname version src;

      nativeBuildInputs = [pkgs.nodejs];

      preBuild = ''
        cp -R ${dependencies}/node_modules ./node_modules
        chmod -R u+w ./node_modules
      '';

      buildPhase = ''
        runHook preBuild
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
        npm run build
      '';

      installPhase = ''
        rm -rf node_modules
        mkdir -p "$out"
        cp -R . "$out/"
      '';

      passthru = {inherit dependencies;};

      meta =
        {
          description = "Millennium plugin ${pname}";
          platforms = lib.platforms.linux;
        }
        // meta;
    };
  in
    plugin;

  plugins = lib.mapAttrs (id: plugin:
    mkMillenniumPlugin {
      pname = id;
      inherit (plugin) version;
      inherit (plugin) packageManager depsHash;
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
