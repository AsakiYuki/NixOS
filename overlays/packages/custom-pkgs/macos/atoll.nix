{pkgs, ...}: 
if pkgs.stdenv.isDarwin then
pkgs.stdenvNoCC.mkDerivation rec {
  version = "2.2.3";
  pname = "atoll"; 

  src = pkgs.fetchurl {
    url = "https://github.com/Ebullioscopic/Atoll/releases/download/v2.3.3/Atoll-2.3.3.dmg";
    hash = "sha256-vaQKuvn1+Kae3nvYONXBzIZeQNxcgTW8EUlBOEAANjQ=";
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

    runHook preInstall
  '';

  sourceRoot = ".";
  dontFixup = true;
} else throw "Atoll only support on darwin!"