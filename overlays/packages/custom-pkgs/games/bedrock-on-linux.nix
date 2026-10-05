{
  pkgs,
  lib,
  data,
  ...
}: let
  pname = "bedrock-on-linux";
  inherit (data.${pname}) version hash;

  unpacked = pkgs.stdenv.mkDerivation {
    inherit pname version;

    src = pkgs.fetchurl {
      inherit hash;
      url = "https://github.com/Wyze3306/BedrockOnLinux/releases/download/v${version}/bedrock-on-linux-${version}-1.x86_64.rpm";
    };

    nativeBuildInputs = [pkgs.rpmextract];

    unpackPhase = ''
      rpmextract $src
    '';

    dontBuild = true;

    installPhase = ''
      mkdir -p $out
      cp -r usr/* $out/
    '';

    postFixup = ''
      if [ -f "$out/share/applications/bedrock-on-linux.desktop" ]; then
        substituteInPlace $out/share/applications/bedrock-on-linux.desktop \
          --replace-warn "Icon=bedrock-on-linux" "Icon=$out/share/icons/hicolor/256x256/apps/bedrock-on-linux.png"
      fi
    '';
  };

  pythonEnv = pkgs.python3.withPackages (ps: [
    ps.cryptography
    ps.pyside6
    ps.pygobject3
  ]);
in
  pkgs.buildFHSEnv {
    name = pname;

    targetPkgs = pkgs: [
      unpacked
      pythonEnv

      pkgs.webkitgtk_4_1
      pkgs.gtk3
      pkgs.libsoup_3
      pkgs.gobject-introspection
      pkgs.glib
      pkgs.glib-networking
      pkgs.gsettings-desktop-schemas
      pkgs.dbus

      pkgs.gst_all_1.gstreamer
      pkgs.gst_all_1.gst-plugins-base
      pkgs.gst_all_1.gst-plugins-good
      pkgs.gst_all_1.gst-plugins-bad
      pkgs.gst_all_1.gst-libav

      pkgs.curl
      pkgs.zstd
      pkgs.gnutar
      pkgs.bubblewrap

      pkgs.stdenv.cc.cc.lib
      pkgs.glibc
      pkgs.zlib
      pkgs.openssl

      pkgs.libGL
      pkgs.libglvnd
      pkgs.vulkan-loader
      pkgs.libX11
      pkgs.libXcomposite
      pkgs.libXdamage
      pkgs.libXext
      pkgs.libXfixes
      pkgs.libXcursor
      pkgs.libXrandr
      pkgs.libXi
      pkgs.libXtst
      pkgs.wayland
      pkgs.libxkbcommon
      pkgs.fontconfig
      pkgs.freetype
      pkgs.harfbuzz
      pkgs.cairo
      pkgs.pango
      pkgs.gdk-pixbuf

      pkgs.libpulseaudio
      pkgs.alsa-lib
    ];

    profile = ''
      export GI_TYPELIB_PATH="/usr/lib/girepository-1.0:/usr/lib64/girepository-1.0:$GI_TYPELIB_PATH"
      export XDG_DATA_DIRS="/usr/share:$GSETTINGS_SCHEMAS_PATH:$XDG_DATA_DIRS"
      export GIO_MODULE_DIR="/usr/lib/gio/modules"
      export LD_LIBRARY_PATH="/usr/lib:/usr/lib64:$LD_LIBRARY_PATH"
      export WEBKIT_DISABLE_SANDBOX_THIS_IS_DANGEROUS=1
      export WEBKIT_FORCE_SANDBOX=0
    '';

    runScript = "bedrock-on-linux";

    extraInstallCommands = ''
      mkdir -p $out/share
      if [ -d "${unpacked}/share/applications" ]; then
        cp -r ${unpacked}/share/applications $out/share/
      fi
      if [ -d "${unpacked}/share/icons" ]; then
        cp -r ${unpacked}/share/icons $out/share/
      fi
    '';

    meta = with lib; {
      description = "Run Minecraft Bedrock for Windows seamlessly on Linux.";
      homepage = "https://github.com/Wyze3306/BedrockOnLinux";
      license = licenses.mit;
      platforms = ["x86_64-linux"];
    };
  }
