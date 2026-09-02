{
  pkgs,
  lib,
  ...
}: let
in (pkgs.stdenv.mkDerivation rec {
  pname = "OpenNOW";
  version = "0.5.5";

  src = pkgs.fetchurl {
    url = "https://github.com/OpenCloudGaming/OpenNOW/releases/download/v${version}/OpenNOW-v${version}-linux-amd64.deb";
    hash = lib.fakeSha256;
  };

  nativeBuildInputs = with pkgs; [
    dpkg
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb --fsys-tarfile $src | tar -x
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/opennow/ $out/usr/
    cp -r ./opt $out/opt/opennow
    cp -r ./usr $out/usr

    runHook postInstall
  '';
})
