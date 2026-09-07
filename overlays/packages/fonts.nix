{pkgs, ...}: {
  tahoma = pkgs.stdenv.mkDerivation {
    pname = "tahoma";
    version = "1.0";
    dontUnpack = true;

    src = pkgs.fetchurl {
      url = "https://static.asakiyuki.com/packages/fonts/tahoma/normal.ttf";
      hash = "sha256-0ZJP1u7KMp5p0iVPdHFHJOe7s9T2gdhrF5HRmy8LNIk=";
    };

    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      cp $src $out/share/fonts/truetype
    '';
  };

  segoe-ui = pkgs.stdenv.mkDerivation {
    pname = "segoe-ui";
    version = "1.0";
    dontUnpack = true;

    src = pkgs.fetchzip {
      url = "https://static.asakiyuki.com/packages/fonts/segoe-ui.tar.gz";
      hash = "sha256-hKEnFyFnQShkcsxAEPz4O3nXftNAiL9cFuzRrHihurw=";
      stripRoot = false;
    };

    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      cp $src/* $out/share/fonts/truetype
    '';
  };
}
