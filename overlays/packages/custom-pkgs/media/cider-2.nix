{
  pkgs,
  data,
  lib ? pkgs.lib,
  ...
}: let
  inherit (pkgs) stdenv;
  ciderData = data.cider-2;
  version =
    if stdenv.isDarwin
    then (ciderData.darwin-version or ciderData.version)
    else ciderData.version;

  pkg-source =
    ciderData.source.${stdenv.system}
    or (throw "Cider-2 is not supported on ${stdenv.system}");

  commonMeta = {
    description = "Powerful music player that allows you listen to your favorite tracks with style";
    homepage = "https://cider.sh";
    license = lib.licenses.unfree;
    mainProgram = "cider-2";
    maintainers = with lib.maintainers; [
      amadejkastelic
      l0r3v
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
in
  if stdenv.isDarwin
  then
    pkgs.stdenvNoCC.mkDerivation rec {
      inherit version;
      pname = "cider-2";

      src = pkgs.fetchurl {
        inherit (pkg-source) hash url;
      };

      nativeBuildInputs = [
        pkgs.undmg
        pkgs.makeWrapper
      ];

      installPhase = ''
        runHook preInstall

        mkdir -p $out/Applications $out/bin
        cp -R Cider.app $out/Applications/
        makeWrapper "$out/Applications/Cider.app/Contents/MacOS/Cider" "$out/bin/${pname}"

        runHook postInstall
      '';

      sourceRoot = ".";
      dontFixup = true;
      meta = commonMeta;
    }
  else
    with pkgs; (stdenv.mkDerivation rec {
      inherit version;
      pname = "cider-2";

      src = pkgs.fetchurl {
        inherit (pkg-source) hash url;
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
        libva
        nspr
        nss
        vulkan-loader
        mesa
        libglvnd
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
        ln -sf ${widevine-cdm}/share/google/chrome/WidevineCdm $out/lib/cider/
      '';

      postFixup = ''
        makeWrapper $out/lib/cider/Cider $out/bin/${pname} \
          --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib:${lib.makeLibraryPath [libGL mesa vulkan-loader libglvnd libgbm libva]}" \
          --set-default LIBGL_DRIVERS_PATH /run/opengl-driver/lib/dri \
          --set-default VK_DRIVER_FILES /run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json \
          --set-default VK_LOADER_LAYERS_DISABLE VK_LAYER_LSFGVK_frame_generation \
          --add-flags "--enable-features=UseOzonePlatform,VaapiVideoDecoder,Vulkan" \
          --add-flags "--enable-unsafe-webgpu" \
          --add-flags "--use-gl=angle" \
          --add-flags "--use-angle=gl" \
          --add-flags "--use-webgpu-adapter=default" \
          --add-flags "--ignore-gpu-blocklist" \
          --add-flags "--ozone-platform-hint=auto" \
          --add-flags "--disable-gpu-sandbox"

        mv $out/share/applications/cider.desktop $out/share/applications/${pname}.desktop
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace-warn 'Exec=cider' 'Exec=${pname}' \
          --replace-warn 'Exec=/usr/lib/cider/Cider' 'Exec=${pname}'

        install -Dm444 $out/share/pixmaps/cider.png \
          $out/share/icons/hicolor/256x256/apps/cider.png

        rm -r $out/share/pixmaps
      '';

      meta = commonMeta;
    })
