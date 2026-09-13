{
  pkgs,
  data,
  get-arch,
  config ? pkgs.config,
  ...
}: let
  inherit (data) zen-browser;

  inherit
    (get-arch {
      "x86_64-linux" = {
        archHash = "amd64";
        archUrl = "x86_64";
      };
      "aarch64-linux" = {
        archHash = "arm64";
        archUrl = "aarch64";
      };
    } "zen-browser")
    archHash
    archUrl
    ;

  policies =
    ((config.zen or {}).policies or {})
    // {
      DisableAppUpdate = true;
    };

  policiesJson = pkgs.writeText "firefox-policies.json" (builtins.toJSON {inherit policies;});
in (pkgs.stdenv.mkDerivation (finalAttrs: rec {
  pname = "zen-browser-unwarpped";
  version = zen-browser.version;
  applicationName = "Zen Browser";

  src = pkgs.fetchzip {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.linux-${archUrl}.tar.xz";
    hash = zen-browser.hash.${archHash};
  };

  nativeBuildInputs = with pkgs; [
    wrapGAppsHook3
    autoPatchelfHook
    patchelfUnstable
  ];

  buildInputs = with pkgs; [
    gtk3
    alsa-lib
    adwaita-icon-theme
    dbus-glib
    libXtst
  ];

  runtimeDependencies = with pkgs; [
    curl
    libva.out
    pciutils
  ];

  appendRunpaths = [
    "${pkgs.pipewire}/lib"
  ];

  installPhase = ''
    mkdir -p "$prefix/lib/zen-${version}"
    cp -r * "$prefix/lib/zen-${version}"

    mkdir -p $out/bin
    ln -s "$prefix/lib/zen-${version}/zen" $out/bin/zen

    mkdir -p "$out/lib/zen-${version}/distribution"
    ln -s ${policiesJson} "$out/lib/zen-${version}/distribution/policies.json"
  '';

  patchelfFlags = ["--no-clobber-old-sections"];

  meta = {
    mainProgram = "zen";
    description = "Zen is a privacy-focused browser that blocks trackers, ads, and other unwanted content while offering the best browsing experience!";
    platforms = ["x86_64-linux" "aarch64-linux"];
  };

  passthru = {
    gtk3 = pkgs.gtk3;
    libName = "zen-${version}";
    binaryName = finalAttrs.meta.mainProgram;
    gssSupport = true;
    ffmpegSupport = true;
  };
}))
