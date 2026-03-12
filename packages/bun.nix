with import <nixpkgs> {};
stdenv.mkDerivation rec {
    pname = "bun";
    version = "1.3.10";
    src =  pkgs.fetchzip {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v1.3.10/bun-linux-x64-baseline.zip";
        sha256 = "sha256-##################################################";
    };

    nativeBuildInputs = [
        
    ];
}