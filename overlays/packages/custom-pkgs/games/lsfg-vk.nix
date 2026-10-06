{pkgs, ...}: let
  # inherit (data) lsfg-vk;
in
  pkgs.stdenv.mkDerivation {
    pname = "lsfg-vk";
    version = "2.0.0.r13.g50845d4";

    src = pkgs.fetchzip {
      url = "https://builds.lsfg-vk.dev/lsfg-vk-2.0.0.r13.g50845d4.tar.xz";
      hash = "sha256-4YhmLR2kVjWCMOl10ARM6iZvbLsLyI03xrWZaJNEDRg=";
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
    ];

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r ./* $out/

      runHook postInstall
    '';
  }
