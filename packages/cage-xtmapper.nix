{ pkgs }:
pkgs.stdenv.mkDerivation rec {
    pname = "cage-xtmapper";
    version = "0.2.0";

    src = pkgs.fetchurl {
        url = "https://github.com/Xtr126/cage-xtmapper/releases/download/v${version}/cage-xtmapper-v${version}.tar";
        hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };

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