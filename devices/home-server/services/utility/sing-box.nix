{
  lib,
  config,
  ...
}: let
  myUUID = "b810b42c-2c93-41a4-96f3-cfb2a657e283";
  private_key = "SIxHf-ekx-4VaWGFlYX0I1s5kXLcLN8dmJdcqWB2n0E";
  # public_key = "iT5idmqFOqTN76-wgakZ9rDiB9hvjzCT5rL9nMhc4xo";
  proxyPort = 9443;
  cfg = config.services.sing-box;
in {
  networking.firewall.allowedTCPPorts = lib.optional cfg.enable [proxyPort];
  networking.firewall.allowedUDPPorts = lib.optional cfg.enable [proxyPort];

  services.sing-box = {
    enable = false;
    settings = {
      log = {level = "info";};
      inbounds = [
        {
          type = "vless";
          tag = "vless-in";
          listen = "::";
          listen_port = proxyPort;
          users = [
            {
              uuid = myUUID;
              flow = "xtls-rprx-vision";
            }
          ];
          tls = {
            enabled = true;
            server_name = "www.microsoft.com";
            reality = {
              enabled = true;
              handshake = {
                server = "www.microsoft.com";
                server_port = 443;
              };
              private_key = private_key;
              short_id = ["30376c6d"];
            };
          };
        }
      ];
      outbounds = [
        {
          type = "direct";
          tag = "direct";
        }
      ];
    };
  };
}
