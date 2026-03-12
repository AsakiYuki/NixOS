{ pkgs, ... }: with pkgs;
stdenv.mkDerivation rec {
    pname = "bun";
    version = "1.3.10";
    src =  pkgs.fetchzip {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v1.3.10/bun-linux-x64-baseline.zip";
        sha256 = "sha256-##################################################";
    };

    dontBuild = true;
    nativeBuildInputs = [ p7zip ];

    unpackPhase = "7z x $src -obun";

    installPhase = ''
        mkdir -p $out/bin
        cp -r bin/* $out/bin
    '';

    meta = with pkgs.lib; {
    	description = "Incredibly fast JavaScript runtime, bundler, transpiler and package manager – all in one";
    	homepage = "https://bun.sh";
    	license = with lib.licenses; [ mit lgpl21Only ];
    };
}