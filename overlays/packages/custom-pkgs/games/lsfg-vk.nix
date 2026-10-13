{
  pkgs,
  lib ? pkgs.lib,
  data ? {},
  ...
}: let
  inherit (pkgs) stdenv;
  lsfgData =
    data.lsfg-vk or {
      version = "2.0.0.r15.geb080c9";
      hash = "sha256-1AGr2ttko0DrPYJ+iF7yOqLY4YNeyZrbNUzMsRSE86U=";
    };
in
  stdenv.mkDerivation rec {
    pname = "lsfg-vk";
    inherit (lsfgData) version;

    src = pkgs.fetchzip {
      url = "https://builds.lsfg-vk.dev/lsfg-vk-${version}.tar.xz";
      inherit (lsfgData) hash;
      stripRoot = false;
    };

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      qt6.wrapQtAppsHook
    ];

    buildInputs = with pkgs; [
      qt6.qtbase
      qt6.qtdeclarative
      stdenv.cc.cc.lib
      vulkan-loader
      libGL
    ];

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r ./* $out/

      runHook postInstall
    '';

    meta = with lib; {
      description = "Lossless Scaling Frame Generation Vulkan layer";
      homepage = "https://builds.lsfg-vk.dev/";
      license = licenses.unfree;
      platforms = ["x86_64-linux"];
      mainProgram = "lsfg-vk-ui";
    };
  }
