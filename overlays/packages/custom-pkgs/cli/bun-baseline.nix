{
  pkgs,
  data,
  ...
}: let
  inherit (data) bun-baseline;
  source = bun-baseline.source.${pkgs.stdenv.system}
    or (throw "Bun baseline is not supported on ${pkgs.stdenv.system}");
in
  pkgs.stdenv.mkDerivation rec {
    pname = "bun";
    version = bun-baseline.version;

    src = pkgs.fetchzip {
      inherit (source) url hash;
    };

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin
      cp bun $out/bin/
      chmod +x $out/bin/bun
    '';

    meta = with pkgs.lib; {
      description = "Incredibly fast JavaScript runtime, bundler, transpiler and package manager - all in one";
      homepage = "https://bun.sh";
      license = with licenses; [
        mit
        lgpl21Only
      ];
      platforms = ["x86_64-linux" "aarch64-linux"];
    };
  }
