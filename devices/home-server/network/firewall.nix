{ ... }: {
  networking.firewall = {
    enable = true;

    allowedUDPPorts = [
      53 # DNS
      853 # DNS-over-QUIC (DoQ)
    ];

    allowedTCPPorts = [
      15523 # SSH
      25565 # Minecraft

      80
      443

      53 # DNS
      853 # DNS-over-TLS (DoT for Android Private DNS)
      3306 # MySQL

      10808 # Steam SOCKS5 (WARP Proxy for LAN)
    ];
  };
}
