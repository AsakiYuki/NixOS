{...}: {
  services.adguardhome = {
    enable = true;
    port = 34778;
    openFirewall = true;
  };
}
