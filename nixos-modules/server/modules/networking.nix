{ config, helper, lib, ... }: let 
    cfg = config.device;
    cfg_s = cfg.services;
in {
    networking = {
        useDHCP = false;
        networkmanager.enable = true;
        defaultGateway = "192.168.1.1";
        nameservers = ["8.8.8.8" "1.1.1.1"];
        
        interfaces = {
            enp1s0 = {
                useDHCP = false;
                ipv4.addresses = [{
                    address = "192.168.1.100";
                    prefixLength = 24;
                }];
            };
        };

        firewall = {
            enable = true;
            allowedUDPPorts = cfg_s.ports.allowed.udp;
            allowedTCPPorts = cfg_s.ports.allowed.tcp
                ++ [
                    cfg_s.vnc-port
                    (lib.mkIf cfg_s.ssh.enable cfg_s.ssh.port)
                    (lib.mkIf cfg_s.sql-server.enable cfg_s.sql-server.port)
                    (lib.mkIf cfg_s.lyrics-server.enable cfg_s.lyrics-server.port)
                    (lib.mkIf cfg_s.public-server.enable cfg_s.public-server.port)
                ]
                ++ (lib.optionals cfg_s.nginx-proxy-manager.enable cfg_s.nginx-proxy-manager.ports);
        };
    };
}