{...}: {
  networking.interfaces = {
    enp1s0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.1.100";
          prefixLength = 24;
        }
      ];

      ipv6.addresses = [
        {
          address = "2402:800:62d0:1c26:abcd:1234:5678:9abc";
          prefixLength = 64;
        }
      ];
    };
  };
}
