{
  pkgs,
  data,
  version ? "latest",
  ...
}: let
  inherit (data) cage-xtmapper;
  selectedVersion = if version == "latest" then cage-xtmapper.defaultVersion else version;
  source = cage-xtmapper.versions.${selectedVersion}.${pkgs.stdenv.system}
    or (throw "cage-xtmapper ${selectedVersion} is not supported on ${pkgs.stdenv.system}");
in
  pkgs.stdenv.mkDerivation {
    pname = "cage-xtmapper";
    version = selectedVersion;

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
      libdisplay-info
      libliftoff
      libinput
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
