{...}: {
  networking.firewall = {
    enable = true;

    allowedUDPPorts = [
      53

      19132 # Minecraft Bedrock
      19133 # Minecraft Bedrock
    ];

    allowedTCPPorts = [
      15523 # SSH

      80
      443

      10767 # Cider-2
      53 # DNS
      3306 # MySQL
    ];
  };
}
