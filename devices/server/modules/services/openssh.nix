{ ... }: let 
    GLOBAL = import ../../../../common/global.nix;
in {
    enable = true;
    ports = [ GLOBAL.SSH_PORT ];
    authorizedKeysInHomedir = true;
    authorizedKeysFiles = [ ".secret/AUTHORIZED_KEYS" ".ssh/authorized_keys" ];
    settings = {
        AllowUsers = [ "asakiyuki" ];
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        AllowAgentForwarding = false;
        AllowStreamLocalForwarding = false;
        X11Forwarding = false;
        PermitRootLogin = "no";
    };
}