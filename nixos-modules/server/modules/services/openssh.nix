{ config, lib, ... }: let 
    cfg = config.device;
in  {
    services.openssh = lib.mkIf cfg.ssh.enable {
        enable = true;
        ports = [ cfg.ssh.port ];
        authorizedKeysInHomedir = true;
        authorizedKeysFiles = [ "/home/asakiyuki/.ssh/authorized_keys" ];
        settings = {
            AllowUsers = cfg.ssh.allow-ssh-users;
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
            AllowAgentForwarding = false;
            AllowStreamLocalForwarding = false;
            X11Forwarding = false;
            PermitRootLogin = "no";
        };
    }
}