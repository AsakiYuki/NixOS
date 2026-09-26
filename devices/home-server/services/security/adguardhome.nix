{...}: {
  services.adguardhome = {
    enable = true;
    port = 34778;
    openFirewall = true;

    settings = {
      dns = {
        bind_hosts = [
          "0.0.0.0"
          "::"
        ];
        port = 53;
        protection_enabled = true;
        filtering_enabled = true;
        aaaa_disabled = true;
        upstream_dns = [
          "https://dns.cloudflare.com/dns-query"
          "https://dns.google/dns-query"
        ];
        bootstrap_dns = [
          "9.9.9.9"
          "1.1.1.1"
        ];
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
      };

      tls = {
        enabled = true;
        server_name = "adguard.asakiyuki.com";
        port_dns_over_tls = 853;
        port_dns_over_quic = 853;
        port_https = 34780;
        certificate_chain = "";
        private_key = "";
        certificate_path = "/var/lib/acme/adguard.asakiyuki.com/fullchain.pem";
        private_key_path = "/var/lib/acme/adguard.asakiyuki.com/key.pem";
      };
    };
  };

  systemd.services.adguardhome = {
    after = [
      "network.target"
      "acme-adguard.asakiyuki.com.service"
    ];
    serviceConfig = {
      SupplementaryGroups = [
        "acme"
        "nginx"
      ];
      ReadOnlyPaths = [
        "/var/lib/acme/adguard.asakiyuki.com"
      ];
    };
  };

  security.acme.certs."adguard.asakiyuki.com".reloadServices = ["adguardhome.service"];
}
