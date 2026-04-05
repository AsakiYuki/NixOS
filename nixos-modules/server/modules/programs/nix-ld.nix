{ pkgs, ... }:
{
  nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      openssl
      zlib
    ];
  };
}

