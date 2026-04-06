{ pkgs, ... }:
pkgs.stdenv.mkDerivation rec {
  pname = "bun";
  version = "1.3.10";

  src = pkgs.fetchzip {
    url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64-baseline.zip";
    hash = "sha256-ZWTs4ApH0BsATxrE1DSuqCETIrNZZxdG8xtN0NinNBw=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp bun $out/bin/
    chmod +x $out/bin/bun
  '';

  meta = with pkgs.lib; {
    description = "Incredibly fast JavaScript runtime, bundler, transpiler and package manager – all in one";
    homepage = "https://bun.sh";
    license = with licenses; [
      mit
      lgpl21Only
    ];
  };
}
