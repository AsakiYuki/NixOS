{...}: {
  networking.firewall = {
    enable = true;

    allowedUDPPorts = [
      53
    ];

    allowedTCPPorts = [
      15523 # SSH
      25565 # Minecraft

      80
      443

      53 # DNS
      3306 # MySQL
    ];
  };
}
