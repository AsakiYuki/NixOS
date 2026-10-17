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

  pkg-hash =
    ciderData.hash.${stdenv.system}
    or (throw "Cider-2 is not support current system: ${stdenv.system}");

  pkg-url =
    if stdenv.isDarwin
    then "https://static.asakiyuki.com/packages/nixos/cider-v${version}-macos-${
      {
        "aarch64-darwin" = "arm64";
        "x86_64-darwin" = "x64";
      }.${
        stdenv.system
      }
        or (throw "Unsupported Darwin system for Cider-2: ${stdenv.system}")
    }.dmg"
    else "https://repo.cider.sh/apt/pool/main/cider-v${version}-linux-${
      {
        "x86_64-linux" = "x64";
        "aarch64-linux" = "arm64";
      }.${
        stdenv.system
      }
        or (throw "Unsupported Linux system for Cider-2: ${stdenv.system}")
    }.deb";

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
      "x86_64-darwin"
    ];
  };
in
  if stdenv.isDarwin
  then
    pkgs.stdenvNoCC.mkDerivation rec {
      inherit version;
      pname = "cider-2";

      src = pkgs.fetchurl {
        hash = pkg-hash;
        url = pkg-url;
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
        hash = pkg-hash;
        url = pkg-url;
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
        ln -sf ${widevine-cdm}/share/google/chrome/WidevineCdm $out/lib/cider/
      '';

      postFixup = ''
        makeWrapper $out/lib/cider/Cider $out/bin/${pname} \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [libGL]}"

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
