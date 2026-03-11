{ ... }: let 
    GLOBAL = import ../../../common/global.nix;
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
            allowedUDPPorts = GLOBAL.SERVER.ALLOWED_UDP_PORTS;
            allowedTCPPorts = GLOBAL.SERVER.ALLOWED_TCP_PORTS;
        };
    };
}