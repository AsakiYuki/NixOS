{
  pkgs,
  data,
  config ? pkgs.config,
  ...
}: let
  inherit (data) zen-browser;

  policies =
    ((config.zen or {}).policies or {})
    // {
      DisableAppUpdate = true;
    };

  policiesJson = pkgs.writeText "firefox-policies.json" (builtins.toJSON {inherit policies;});

  runtimeLibs = with pkgs; [
    libGL
    libglvnd
    mesa
    vulkan-loader
    pciutils
    pipewire
    ffmpeg
    libva
    libpulseaudio
    fontconfig
    freetype
    libxkbcommon
    wayland
    gtk3
    dbus-glib
  ];
in (pkgs.stdenv.mkDerivation (finalAttrs: rec {
  pname = "zen-browser";
  version = zen-browser.version;

  src = pkgs.fetchzip {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.linux-x86_64.tar.xz";
    hash = zen-browser.hash.x86_64-linux;
  };

  nativeBuildInputs = with pkgs; [
    wrapGAppsHook3
    autoPatchelfHook
    patchelfUnstable
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = with pkgs; [
    gtk3
    alsa-lib
    adwaita-icon-theme
    dbus-glib
    libXtst
    libxkbcommon
    wayland
  ];

  runtimeDependencies = with pkgs; [
    curl
    libva.out
    pciutils
    ffmpeg
    mesa
    libglvnd
    vulkan-loader
  ];

  appendRunpaths = [
    "${pkgs.pipewire}/lib"
    "${pkgs.ffmpeg}/lib"
    "/run/opengl-driver/lib"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/zen-${version}"
    cp -r * "$out/lib/zen-${version}"

    mkdir -p "$out/lib/zen-${version}/distribution"
    ln -s ${policiesJson} "$out/lib/zen-${version}/distribution/policies.json"

    mkdir -p "$out/bin"
    makeWrapper "$out/lib/zen-${version}/zen" "$out/bin/zen" \
      --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath runtimeLibs}:/run/opengl-driver/lib" \
      --set-default MOZ_ENABLE_WAYLAND "1" \
      --set-default MOZ_WEBRENDER "1" \
      --set-default MOZ_ACCELERATED "1" \
      --set-default EGL_PLATFORM "wayland"

    for size in 16 32 48 64 128; do
      icon_src="$out/lib/zen-${version}/browser/chrome/icons/default/default$size.png"
      if [ -f "$icon_src" ]; then
        mkdir -p "$out/share/icons/hicolor/''${size}x''${size}/apps"
        ln -s "$icon_src" "$out/share/icons/hicolor/''${size}x''${size}/apps/zen.png"
      fi
    done

    runHook postInstall
  '';

  desktopItems = [
    (pkgs.makeDesktopItem {
      name = "zen";
      exec = "zen %u";
      icon = "zen";
      desktopName = "Zen Browser";
      genericName = "Web Browser";
      categories = ["Network" "WebBrowser"];
      mimeTypes = [
        "text/html"
        "text/xml"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
      startupWMClass = "zen-alpha";
    })
  ];

  patchelfFlags = ["--no-clobber-old-sections"];

  meta = {
    mainProgram = "zen";
    description = "Zen is a privacy-focused browser that blocks trackers, ads, and other unwanted content while offering the best browsing experience!";
  };

  passthru = {
    gtk = pkgs.gtk3;
    libName = "zen-${version}";
    binaryName = finalAttrs.meta.mainProgram;
    gssSupport = true;
    ffmpegSupport = true;
  };
}))
