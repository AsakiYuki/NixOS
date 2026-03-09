{ ... }: let 
    GLOBAL = import ../../../../global/global.nix {};
in {
    httpd = {
        enable = true;
        adminAddr = GLOBAL.ADMIN_EMAIL;
    };
}