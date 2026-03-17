{ ... }: let 
    GLOBAL = import ../../_global.nix;
in {
    enable = true;
    ports = [ GLOBAL.SSH_PORT ];
    authorizedKeysInHomedir = true;
    authorizedKeysFiles = [ "/home/asakiyuki/.ssh/authorized_keys" ];
    settings = {
        AllowUsers = GLOBAL.ALLOWED_SSH_USERS;
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        AllowAgentForwarding = false;
        AllowStreamLocalForwarding = false;
        X11Forwarding = false;
        PermitRootLogin = "no";
    };
}