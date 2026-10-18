{
  pkgs,
  data,
  version ? "0.2.0",
  ...
}: let
  inherit (data) cage-xtmapper;
  release = cage-xtmapper.release;
  source = cage-xtmapper.versions.${version}.${pkgs.stdenv.system}
    or (throw "cage-xtmapper ${version} is not supported on ${pkgs.stdenv.system}");
in
  pkgs.stdenv.mkDerivation {
    pname = "cage-xtmapper";
    version = version;

    src = pkgs.fetchurl {
      inherit (source) url hash;
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
