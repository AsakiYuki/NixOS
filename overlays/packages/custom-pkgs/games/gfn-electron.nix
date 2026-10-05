{
  pkgs,
  data,
  lib,
  ...
}: let
  inherit (data) gfn-electron;
in
  pkgs.stdenv.mkDerivation rec {
    pname = "geforce-now-electron";
    version = gfn-electron.version;

    src = pkgs.fetchzip {
      url = "https://github.com/hmlendea/gfn-electron/releases/download/v${version}/geforcenow-electron_${version}_linux.zip";
      hash = gfn-electron.hash;
      stripRoot = false;
    };

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      wrapGAppsHook3
      makeWrapper
    ];

    buildInputs = with pkgs; [
      nspr
      nss
      gtk3
      glib
      alsa-lib
      mesa
      libdrm
      libxkbcommon
      cups
      pango
      cairo
      atk
      at-spi2-atk
      at-spi2-core
      dbus
      expat
      systemd

      libx11
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxrandr
      libxcb
      libxcursor
      libxi
      libxrender
      libxtst
      libxscrnsaver
    ];
    autoPatchelfIgnoreMissingDeps = [
      "libvulkan.so.1"
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/opt/geforcenow-electron $out/bin $out/share/applications $out/share/icons/hicolor/scalable/apps
      cp -r ./* $out/opt/geforcenow-electron/

      cp ./com.github.hmlendea.geforcenow-electron.desktop $out/share/applications/

      substituteInPlace $out/share/applications/com.github.hmlendea.geforcenow-electron.desktop \
        --replace-fail "/opt/geforcenow-electron/geforcenow-electron" "$out/bin/geforcenow-electron"

      chmod +x $out/opt/geforcenow-electron/geforcenow-electron

      makeWrapper $out/opt/geforcenow-electron/geforcenow-electron $out/bin/geforcenow-electron \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [pkgs.mesa pkgs.vulkan-loader pkgs.libglvnd]}"

      runHook postInstall
    '';

    meta = with lib; {
      description = "GeForce NOW Electron client";
      homepage = "https://github.com/hmlendea/gfn-electron";
      license = licenses.gpl3Only;
      platforms = ["x86_64-linux"];
      mainProgram = "geforcenow-electron";
    };
  }
