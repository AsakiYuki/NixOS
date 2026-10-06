{pkgs, ...}:
if (pkgs.stdenv.isDarwin)
then
  (pkgs.stdenv.mkDerivation {
    version = "0.11.12";
    pname = "tinycast";

    src = pkgs.fetchzip {
      url = "https://github.com/abue-ammar/tinycast/releases/download/v0.11.12/Tinycast-0.11.12.zip";
      hash = "sha256-vM4Yo7Ah8Dj9TdK4g4YZ9mZHtUlbCohsb1X2DP08asc=";
    };

    nativeBuildInputs = [
      pkgs.makeWrapper
    ];

    dontBuild = true;
    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications/Tinycast.app $out/bin
      cp -R $src/* $out/Applications/Tinycast.app

      runHook postInstall
    '';
  })
else throw "tinycast is mac support only!"
