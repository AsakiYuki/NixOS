{config, ...}: {
  services = {
    cloudflare-warp.enable = true;

    cloudflare-dyndns = {
      enable = true;
      apiTokenFile = config.age.secrets.cloudflare.path;
      frequency = "*:0/5";
      proxied = false;
      ipv6 = false;
      ipv4 = true;
      deleteMissing = false;
      domains = [
        "asakiyuki.com"
        "ddns.asakiyuki.com"
        "mx1.asakiyuki.com"
      ];
    };
  };
}
