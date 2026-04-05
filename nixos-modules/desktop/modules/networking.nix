{ ... }:
{
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    nftables.enable = true;
    firewall.trustedInterfaces = [ "waydroid0" ];
  };
}

