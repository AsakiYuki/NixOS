{
  pkgs,
  data,
  lib ? pkgs.lib,
  ...
}:
let
  inherit (pkgs) stdenv;
  resolverData = data.cider-mv-resolver;
  source =
    resolverData.source.${stdenv.system}
      or (throw "Cider MV Resolver is not supported on ${stdenv.system}");
  runtimeLibs = lib.optionals stdenv.isLinux [ pkgs.icu ];
  src = pkgs.fetchzip {
    inherit (source) url hash;
    stripRoot = true;
  };
in
stdenv.mkDerivation {
  pname = "cider-mv-resolver";
  version = resolverData.version;
  inherit src;

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    pkgs.autoPatchelfHook
  ];
  buildInputs =
    lib.optionals stdenv.isLinux [
      pkgs.zlib
      stdenv.cc.cc.lib
    ]
    ++ runtimeLibs;

  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 CiderMvResolver $out/libexec/cider-mv-resolver/CiderMvResolver
    install -Dm755 yt-dlp $out/libexec/cider-mv-resolver/yt-dlp
    install -Dm644 YT-DLP-COPYING.txt $out/share/licenses/cider-mv-resolver/YT-DLP-COPYING.txt
    install -Dm644 THIRD_PARTY_NOTICES.md $out/share/licenses/cider-mv-resolver/THIRD_PARTY_NOTICES.md
    install -Dm644 README_EN.md $out/share/doc/cider-mv-resolver/README.md
    install -Dm755 install.sh $out/share/cider-mv-resolver/install.sh
    install -Dm755 uninstall.sh $out/share/cider-mv-resolver/uninstall.sh
    ln -s $out/libexec/cider-mv-resolver/CiderMvResolver $out/share/cider-mv-resolver/CiderMvResolver
    ln -s $out/libexec/cider-mv-resolver/yt-dlp $out/share/cider-mv-resolver/yt-dlp

    mkdir -p $out/bin
    cat > $out/bin/cider-mv-resolver <<'EOF'
    #!${stdenv.shell}
    data_dir="''${XDG_DATA_HOME:-$HOME/.local/share}/CiderMvResolver"
    mkdir -p "$data_dir"
    ln -sfn ${placeholder "out"}/libexec/cider-mv-resolver/yt-dlp "$data_dir/yt-dlp"
    ${lib.optionalString stdenv.isLinux ''
      export LD_LIBRARY_PATH="${lib.makeLibraryPath runtimeLibs}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    ''}
    cd "$data_dir"
    exec ${placeholder "out"}/libexec/cider-mv-resolver/CiderMvResolver
    EOF
    chmod +x $out/bin/cider-mv-resolver

    cat > $out/bin/cider-mv-resolver-install <<'EOF'
    #!${stdenv.shell}
    exec ${placeholder "out"}/share/cider-mv-resolver/install.sh "$@"
    EOF
    chmod +x $out/bin/cider-mv-resolver-install

    cat > $out/bin/cider-mv-resolver-uninstall <<'EOF'
    #!${stdenv.shell}
    exec ${placeholder "out"}/share/cider-mv-resolver/uninstall.sh "$@"
    EOF
    chmod +x $out/bin/cider-mv-resolver-uninstall

    runHook postInstall
  '';

  meta = with lib; {
    description = "Local YouTube URL resolver companion for Cider MV Immersive";
    homepage = "https://github.com/YoreYore33/Cider-MV-Resolver";
    license = licenses.unfree;
    mainProgram = "cider-mv-resolver";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
