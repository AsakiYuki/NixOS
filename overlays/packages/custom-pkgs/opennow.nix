{pkgs, ...}:
pkgs.stdenv.mkDerivation rec {
  pname = "opennow";
  version = "0.5.5";

  src = pkgs.fetchurl {
    url = "https://github.com/OpenCloudGaming/OpenNOW/releases/download/v${version}/OpenNOW-v${version}-linux-amd64.deb";
    hash = "sha256-iTWPhDPIpXPJjLl5And/IrAlFzM6pavD7xz3A0GhprY=";
  };

  nativeBuildInputs = with pkgs; [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = with pkgs; [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libdrm
    libxkbcommon
    mesa
    nspr
    nss
    pango
    udev
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxcb

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb --fsys-tarfile "$src" | tar -x
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/opennow" "$out/bin"
    cp -r opt/OpenNOW/* "$out/lib/opennow/"

    if [ -d usr/share ]; then
      cp -r usr/share "$out/"
    fi

    desktopFile="$out/share/applications/com.zortos.opennow.stable.desktop"
    if [ -f "$desktopFile" ]; then
      substituteInPlace "$desktopFile" \
        --replace-fail "/opt/OpenNOW/opennow-stable" "$out/bin/opennow-stable"
    fi

    makeWrapper "$out/lib/opennow/opennow-stable" "$out/bin/opennow-stable" \
      --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath buildInputs}" \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${pkgs.lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with pkgs.gst_all_1; [gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad])}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    ln -s "$out/bin/opennow-stable" "$out/bin/opennow"

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Custom GeForce Now Client Named OpenNOW";
    homepage = "https://github.com/OpenCloudGaming/OpenNOW";
    license = licenses.mit;
    mainProgram = "opennow-stable";
    platforms = ["x86_64-linux"];
    sourceProvenance = with sourceTypes; [binaryNativeCode];
  };
}
