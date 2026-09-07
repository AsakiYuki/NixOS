{
  pkgs,
  lib,
  ...
}: {
  tahoma = pkgs.stdenv.mkDerivation {
    pname = "tahoma";
    version = "1.0";
    dontUnpack = true;

    src = pkgs.fetchurl {
      url = "https://static.asakiyuki.com/packages/fonts/tahoma/normal.ttf";
      hash = lib.fakeHash;
    };

    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      cp $src $out/share/fonts/truetype
    '';
  };
}
