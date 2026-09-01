{
  pkgs,
  lib,
  version ? "0.2.0",
  ...
}: let
  data = (lib.importJSON ../../../../assets/packages.json).cage-xtmapper;
  release = data.release;
  hash = data."version-${version}";
in
  pkgs.stdenv.mkDerivation {
    pname = "cage-xtmapper";
    version = version;

    src = pkgs.fetchurl {
      url = "https://github.com/Xtr126/cage-xtmapper/releases/download/v${release}/cage-xtmapper-v${version}.tar";
      hash = hash;
    };

    nativeBuildInputs = [pkgs.autoPatchelfHook];

    buildInputs = with pkgs; [
      wayland
      libxkbcommon
      pixman
      libdrm
      libGL
      mesa
      vulkan-loader
      udev
      seatd
      libxcb-render-util
    ];

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin
      tar xvf $src
      cp usr/local/bin/cage_xtmapper $out/bin/
      cp usr/local/bin/cage_xtmapper.sh $out/bin/
      chmod +x $out/bin/cage_xtmapper
      chmod +x $out/bin/cage_xtmapper.sh
    '';

    meta = with pkgs.lib; {
      description = "cage-xtmapper input mapping tool";
      homepage = "https://github.com/Xtr126/cage-xtmapper";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  }
