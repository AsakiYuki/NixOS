{ ... }: let 
    GLOBAL = import ../../../../global/global.nix;
in {
    enable = true;
    authorizedKeysFiles = [ 
        "/home/asakiyuki/.secret/AUTHORIZED_KEYS"
     ];
    ports = [ GLOBAL.SSH_PORT ];
    settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        KbdInteractiveAuthentication = false;
    };
}