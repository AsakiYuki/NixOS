{
  pkgs,
  data,
  ...
}: let
  inherit (data.cider-2) version hash;
in (
  with pkgs; (stdenv.mkDerivation rec {
    inherit version;
    pname = "cider-2";

    src = pkgs.fetchurl {
      inherit hash;
      url = "https://static.asakiyuki.com/packages/nixos/cider-v${version}-linux-x64.deb";
    };

    nativeBuildInputs = [
      asar
      dpkg
      autoPatchelfHook
      makeWrapper
    ];

    buildInputs = [
      alsa-lib
      gtk3
      libgbm
      libGL
      nspr
      nss
    ];

    unpackPhase = ''
      runHook preUnpack
      dpkg-deb --fsys-tarfile $src | tar -x
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,share,lib}
      cp -r usr/share/* $out/share/
      cp -r usr/lib/* $out/lib/

      chmod +x $out/lib/cider/Cider

      runHook postInstall
    '';

    postInstall = ''
      ${lib.getExe asar} extract $out/lib/cider/resources/app.asar ./cider-build

      # Patch login popup webview creation
      substituteInPlace ./cider-build/.vite/build/events-*.js \
        --replace-warn 'else if(c.includes(r))return{action:"allow"}' 'else if(c.includes(r))return{action:"allow",overrideBrowserWindowOptions:{webPreferences:{devTools:!0,nodeIntegration:!1,contextIsolation:!0,webSecurity:!1,sandbox:!1,experimentalFeatures:!0}}}'

      ${lib.getExe asar} pack ./cider-build $out/lib/cider/resources/app.asar
      rm -rf ./cider-build

      # Install Widevine CDM for DRM support
      ln -sf ${widevine-cdm}/share/google/chrome/WidevineCdm $out/lib/cider/
    '';

    postFixup = ''
      makeWrapper $out/lib/cider/Cider $out/bin/${pname} \
        --add-flags "\$\{NIXOS_OZONE_WL:+\$\{WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true\}\}" \
        --add-flags "--no-sandbox --disable-gpu-sandbox" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [libGL]}"

      mv $out/share/applications/cider.desktop $out/share/applications/${pname}.desktop
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-warn 'Exec=cider' 'Exec=${pname}' \
        --replace-warn 'Exec=/usr/lib/cider/Cider' 'Exec=${pname}'

      install -Dm444 $out/share/pixmaps/cider.png \
        $out/share/icons/hicolor/256x256/apps/cider.png

      rm -r $out/share/pixmaps
    '';

    meta = {
      description = "Powerful music player that allows you listen to your favorite tracks with style";
      homepage = "https://cider.sh";
      license = lib.licenses.unfree;
      mainProgram = "cider-2";
      maintainers = with lib.maintainers; [
        amadejkastelic
        l0r3v
      ];
      platforms = ["x86_64-linux"];
    };
  })
)
