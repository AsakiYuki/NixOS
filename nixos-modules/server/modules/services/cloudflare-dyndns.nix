{ ... }:
{
  services.cloudflare-dyndns = {
    enable = true;
    apiTokenFile = "/home/asakiyuki/.secret/CLOUDFLARE_TOKEN_KEY";
    frequency = "*:0/5";
    proxied = true;
    ipv6 = false;
    ipv4 = true;
    deleteMissing = false;
    domains = [ "ddns.asakiyuki.com" ];
  };
}
