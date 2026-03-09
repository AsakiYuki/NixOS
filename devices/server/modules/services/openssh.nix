{ ... }: let 
    GLOBAL = import ../../../../global/global.nix;
in {
    enable = true;
    authorizedKeysFiles = [ GLOBAL.AUTHORIZED_KEYS ];
    ports = [ GLOBAL.SSH_PORT ];
    settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "prohibit-password";
        KbdInteractiveAuthentication = false;
    };
}