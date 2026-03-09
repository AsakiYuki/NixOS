{ ... }: let 
    GLOBAL = import ../../../../global/global.nix;
in {
    enable = true;
    adminAddr = GLOBAL.ADMIN_EMAIL;
}