{...}: {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      10767
      # 24642 # Stardew Valley
    ];
    allowedUDPPorts = [
      # 24642 # Stardew Valley
    ];
  };
}
