{
  pkgs,
  data,
  ...
}: let
  inherit (data) lsfg-vk;
in
  pkgs.stdenv.mkDerivation rec {
    pname = "lsfg-vk";
    version = lsfg-vk.version;

    src = pkgs.fetchzip {
      url = "https://github.com/PancakeTAS/lsfg-vk/releases/download/v${version}-dev/lsfg-vk-${version}-dev${lsfg-vk.dev-version}-linux.tar.xz";
      hash = lsfg-vk.hash;
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
