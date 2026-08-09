{...}: {
  networking = {
    useDHCP = true;
    defaultGateway = "192.168.1.1";
    nameservers = ["8.8.8.8" "1.1.1.1"];
  };
}
