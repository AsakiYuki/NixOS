{ config, lib, ... }: let 
    cfg = config.device;
in  {
    services.openssh = lib.mkIf cfg.services.ssh.enable {
        enable = true;
        ports = [ cfg.services.ssh.port ];
        authorizedKeysInHomedir = true;
        authorizedKeysFiles = [ "/home/asakiyuki/.ssh/authorized_keys" ];
        settings = {
            AllowUsers = cfg.services.ssh.allowed-users;
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
            AllowAgentForwarding = false;
            AllowStreamLocalForwarding = false;
            X11Forwarding = false;
            PermitRootLogin = "no";
        };
    };
}