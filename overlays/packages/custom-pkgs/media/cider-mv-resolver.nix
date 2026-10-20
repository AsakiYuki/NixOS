{
  pkgs,
  data,
  lib ? pkgs.lib,
  ...
}:
let
  inherit (pkgs) stdenv;

  resolver = data.cider-mv-resolver;
  source =
    resolver.source.${stdenv.system}
      or (throw "Cider MV Resolver is not supported on ${stdenv.system}");

  runtimeLibraries = lib.optionals stdenv.isLinux [
    pkgs.icu
    pkgs.openssl
  ];

  ytDlpWrapper = ''
    #!${stdenv.shell}
    exec ${placeholder "out"}/bin/cider-mv-resolver-yt-dlp "$@"
  '';

  ytDlpLauncher = ''
    #!${stdenv.shell}
    yt_dlp="''${CIDER_MV_RESOLVER_YT_DLP_REAL:-${placeholder "out"}/libexec/cider-mv-resolver/yt-dlp-unwrapped}"
    config="''${CIDER_MV_RESOLVER_YT_DLP_CONFIG:-''${XDG_CONFIG_HOME:-$HOME/.config}/yt-dlp/config}"
    export PATH="${pkgs.deno}/bin:''${PATH:-}"

    yt_dlp_args=()
    requested_format=""
    while (($#)); do
      case "$1" in
        --format|-f)
          if (($# > 1)); then
            requested_format="$2"
            shift 2
          else
            yt_dlp_args+=("$1")
            shift
          fi
          ;;
        --format=*)
          requested_format="''${1#*=}"
          shift
          ;;
        *)
          yt_dlp_args+=("$1")
          shift
          ;;
      esac
    done

    format_args=()
    if [[ "$requested_format" =~ height\<=([0-9]+) ]]; then
      max_height="''${BASH_REMATCH[1]}"
      format_args+=(
        --format "bestvideo[height<=$max_height][format_note*=Premium][protocol^=http]/bestvideo[height<=$max_height][format_id*=sr][protocol^=http]/bestvideo[height<=$max_height][protocol^=http]"
        --format-sort "res,br"
        --format-sort-force
      )
    elif [ -n "$requested_format" ]; then
      format_args+=(--format "$requested_format")
    fi

    cookies_from_browser="''${CIDER_MV_RESOLVER_COOKIES_FROM_BROWSER-firefox}"
    extra_args=()
    if [ -n "$cookies_from_browser" ]; then
      extra_args+=(--cookies-from-browser "$cookies_from_browser")
    fi

    if [ -r "$config" ]; then
      exec "$yt_dlp" --config-locations "$config" "''${yt_dlp_args[@]}" "''${format_args[@]}" "''${extra_args[@]}"
    fi
    exec "$yt_dlp" "''${yt_dlp_args[@]}" "''${format_args[@]}" "''${extra_args[@]}"
  '';

  resolverLauncher = ''
    #!${stdenv.shell}
    data_dir="''${XDG_DATA_HOME:-$HOME/.local/share}/CiderMvResolver"
    mkdir -p "$data_dir"
    yt_dlp="''${CIDER_MV_RESOLVER_YT_DLP:-${placeholder "out"}/bin/cider-mv-resolver-yt-dlp}"
    ln -sfn "$yt_dlp" "$data_dir/yt-dlp"
    ${lib.optionalString stdenv.isLinux ''
      export LD_LIBRARY_PATH="${lib.makeLibraryPath runtimeLibraries}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    ''}
    cd "$data_dir"
    exec ${placeholder "out"}/libexec/cider-mv-resolver/CiderMvResolver
  '';

  utilityLauncher = name: ''
    #!${stdenv.shell}
    exec ${placeholder "out"}/share/cider-mv-resolver/${name}.sh "$@"
  '';

  src = pkgs.fetchzip {
    inherit (source) url hash;
    stripRoot = true;
  };
in
stdenv.mkDerivation {
  pname = "cider-mv-resolver";
  version = resolver.version;
  inherit src;

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkgs.autoPatchelfHook ];
  buildInputs =
    lib.optionals stdenv.isLinux [
      pkgs.zlib
      stdenv.cc.cc.lib
    ]
    ++ runtimeLibraries;

  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    appDir=$out/libexec/cider-mv-resolver
    binDir=$out/bin
    docDir=$out/share/doc/cider-mv-resolver
    licenseDir=$out/share/licenses/cider-mv-resolver
    shareDir=$out/share/cider-mv-resolver
    mkdir -p "$binDir"

    install -Dm755 CiderMvResolver "$appDir/CiderMvResolver"
    install -Dm755 yt-dlp "$appDir/yt-dlp-unwrapped"
    install -Dm644 YT-DLP-COPYING.txt "$licenseDir/YT-DLP-COPYING.txt"
    install -Dm644 THIRD_PARTY_NOTICES.md "$licenseDir/THIRD_PARTY_NOTICES.md"
    install -Dm644 README_EN.md "$docDir/README.md"
    install -Dm755 install.sh "$shareDir/install.sh"
    install -Dm755 uninstall.sh "$shareDir/uninstall.sh"

    cat > "$appDir/yt-dlp" <<'EOF'
    ${ytDlpWrapper}
    EOF
    cat > "$binDir/cider-mv-resolver-yt-dlp" <<'EOF'
    ${ytDlpLauncher}
    EOF
    cat > "$binDir/cider-mv-resolver" <<'EOF'
    ${resolverLauncher}
    EOF
    cat > "$binDir/cider-mv-resolver-install" <<'EOF'
    ${utilityLauncher "install"}
    EOF
    cat > "$binDir/cider-mv-resolver-uninstall" <<'EOF'
    ${utilityLauncher "uninstall"}
    EOF

    chmod +x \
      "$appDir/yt-dlp" \
      "$binDir/cider-mv-resolver-yt-dlp" \
      "$binDir/cider-mv-resolver" \
      "$binDir/cider-mv-resolver-install" \
      "$binDir/cider-mv-resolver-uninstall"

    ln -s "$appDir/CiderMvResolver" "$shareDir/CiderMvResolver"
    ln -s "$appDir/yt-dlp" "$shareDir/yt-dlp"

    runHook postInstall
  '';

  meta = {
    description = "Local YouTube URL resolver companion for Cider MV Immersive";
    homepage = "https://github.com/YoreYore33/Cider-MV-Resolver";
    license = lib.licenses.unfree;
    mainProgram = "cider-mv-resolver";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
