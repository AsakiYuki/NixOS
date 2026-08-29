{lib, ...}: let
    extensions = import ./extensions.nix;
in lib.mergeAttrsList [
    extensions
]