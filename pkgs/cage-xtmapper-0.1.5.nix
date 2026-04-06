{ pkgs, ... }:
let
  RELEASE_VERSION = "20260208";
  PACKAGE_VERSION = "0.1.5";
in
pkgs.stdenv.mkDerivation rec {
  pname = "cage-xtmapper";
  version = PACKAGE_VERSION;

  src = pkgs.fetchurl {
    url = "https://github.com/Xtr126/cage-xtmapper/releases/download/v${RELEASE_VERSION}/cage-xtmapper-v${PACKAGE_VERSION}.tar";
    hash = "sha256-ZmdltOQInGbCBpf/e8D2sB9Rjt4wqd8wwuSFvryHfFA=";
  };

  nativeBuildInputs = [ pkgs.autoPatchelfHook ];

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

