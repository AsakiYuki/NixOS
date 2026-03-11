{ }: 
stdenv.mkDerivation (attrs: {
    pname = "bun";
    version = "1.3.10";
    src = with atts; {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64-baseline.zip";
        hash = "sha256-###########################";
    };
})