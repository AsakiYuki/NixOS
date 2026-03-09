{ ... }: let 
    GLOBAL = import ../../../../global/global.nix;
in {
    enable = true;
    authorizedKeysFiles = [ GLOBAL.AUTHORIZED_KEYS ];
}