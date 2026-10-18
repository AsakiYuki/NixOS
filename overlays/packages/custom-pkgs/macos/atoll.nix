{
  pkgs,
  data,
  ...
}:
if pkgs.stdenv.isDarwin
then let
  inherit (data.atoll) version;
  source = data.atoll.source."universal-darwin";
in
  pkgs.stdenvNoCC.mkDerivation rec {
    inherit version;
    pname = "atoll";

    src = pkgs.fetchurl {
      inherit (source) hash url;
    };

    nativeBuildInputs = [
      pkgs.undmg
      pkgs.makeWrapper
    ];

    unpackCmd = ''
      echo "Mounting DMG..."
      MOUNT_DIR=$(mktemp -d -t atoll-mount-XXXXXX)
      /usr/bin/hdiutil attach "$curSrc" -mountpoint "$MOUNT_DIR" -nobrowse -readonly

      echo "Extracting Atoll.app..."
      cp -R "$MOUNT_DIR/Atoll.app" .

      echo "Unmounting DMG..."
      /usr/bin/hdiutil eject "$MOUNT_DIR"
      rmdir "$MOUNT_DIR"
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications $out/bin
      cp -R Atoll.app $out/Applications/
      makeWrapper "$out/Applications/Atoll.app/Contents/MacOS/Atoll" "$out/bin/${pname}"

      runHook postInstall
    '';

    sourceRoot = ".";
    dontFixup = true;
  }
else throw "Atoll only support on darwin!"
