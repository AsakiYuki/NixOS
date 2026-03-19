{ ... }: {
    networking = {
        hostName = "nixos";
        networkmanager.enable = true;
        firewall.trustedInterfaces = [ "waydroid0" ];
    };
}