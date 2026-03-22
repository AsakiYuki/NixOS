{ pkgs, ... }: {
    programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
            stdenv.cc.cc
            zlib
            
            brotli
            unixODBC
            zstd
            glib
            stdenv.cc.cc.lib
        ];
    };
}