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
      hash = {
        "x86_64-linux" = "sha256-nT50LVxFEtCxvJsGp5cztgBO8aEWVtZKTEeapAh8p7M=";
        "aarch64-linux" = "sha256-oOz/kj3EU+EhIfzD75tfopifGdnQbIaHMzfPJZrQgjM=";
      };
    };

  version = photocraftData.version;

  arch =
    {
      "x86_64-linux" = "x86_64";
      "aarch64-linux" = "aarch64";
    }.${
      stdenv.system
    }
    or (throw "Unsupported architecture for Photocraft: ${stdenv.system}");

  pkgHash =
    if builtins.isAttrs photocraftData.hash
    then (photocraftData.hash.${stdenv.system}
        or (throw "Unsupported architecture hash for Photocraft: ${stdenv.system}"))
    else photocraftData.hash;

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
      url = "https://github.com/storytold/photocraft/releases/download/v${version}/photocraft-${version}-linux-${arch}.tar.gz";
      hash = pkgHash;
    };

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      makeWrapper
    ];

    buildInputs = with pkgs; [
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
