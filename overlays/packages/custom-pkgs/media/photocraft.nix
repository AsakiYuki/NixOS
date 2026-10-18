{
  pkgs,
  lib ? pkgs.lib,
  data ? {},
  ...
}: let
  inherit (pkgs) stdenv;
  photocraftData =
    data.photocraft or {
      version = "0.8.2";
      source = {
        "x86_64-linux" = {
          url = "https://github.com/storytold/photocraft/releases/download/v0.8.2/photocraft-0.8.2-linux-x86_64.tar.gz";
          hash = "sha256-nT50LVxFEtCxvJsGp5cztgBO8aEWVtZKTEeapAh8p7M=";
        };
        "aarch64-linux" = {
          url = "https://github.com/storytold/photocraft/releases/download/v0.8.2/photocraft-0.8.2-linux-aarch64.tar.gz";
          hash = "sha256-oOz/kj3EU+EhIfzD75tfopifGdnQbIaHMzfPJZrQgjM=";
        };
      };
    };

  version = photocraftData.version;

  source = photocraftData.source.${stdenv.system}
    or (throw "Photocraft is not supported on ${stdenv.system}");

  runtimeLibs = with pkgs; [
    wayland
    libxkbcommon
    libGL
    vulkan-loader
    libx11
    libxcursor
    libxi
    libxrandr
    dbus.lib
  ];
in
  stdenv.mkDerivation rec {
    pname = "photocraft";
    inherit version;

    src = pkgs.fetchzip {
      inherit (source) url hash;
    };

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      makeWrapper
    ];

    buildInputs = [
      stdenv.cc.cc.lib
    ];

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share
      cp -r bin/* $out/bin/
      cp -r share/* $out/share/
      chmod +x $out/bin/*

      runHook postInstall
    '';

    postFixup = ''
      wrapProgram $out/bin/photocraft \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"
    '';

    meta = with lib; {
      description = "Open-source clean-room reimplementation of Photoshop in pure Rust";
      homepage = "https://github.com/storytold/photocraft";
      license = with licenses; [mit asl20];
      mainProgram = "photocraft";
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    };
  }
