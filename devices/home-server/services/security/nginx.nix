{
  pkgs,
  lib,
  ...
}:
let
  pacFile = toString (pkgs.writeText "proxy.pac" (lib.readRootFile "/assets/public/proxy.pac"));
in
{
  services.nginx = {
    enable = true;

    streamConfig = ''
      server {
        listen 10808;
        listen [::]:10808;
        allow 127.0.0.1;
        allow 192.168.0.0/16;
        allow 100.64.0.0/10;
        deny all;
        proxy_pass 127.0.0.1:1080;
      }
    '';

    commonHttpConfig = ''
      set_real_ip_from 103.21.244.0/22;
      set_real_ip_from 103.22.200.0/22;
      set_real_ip_from 103.31.4.0/22;
      set_real_ip_from 141.101.64.0/18;
      set_real_ip_from 108.162.192.0/18;
      set_real_ip_from 190.93.240.0/20;
      set_real_ip_from 188.114.96.0/20;
      set_real_ip_from 197.234.240.0/22;
      set_real_ip_from 198.41.128.0/17;
      set_real_ip_from 162.158.0.0/15;
      set_real_ip_from 104.16.0.0/13;
      set_real_ip_from 104.24.0.0/14;
      set_real_ip_from 172.64.0.0/13;
      set_real_ip_from 131.0.72.0/22;

      real_ip_header CF-Connecting-IP;
    '';

    package = pkgs.nginx;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    enableReload = true;
    virtualHosts = {
      "_" = {
        default = true;
        rejectSSL = true;
        locations."= /proxy.pac" = {
          alias = pacFile;
          extraConfig = ''
            default_type application/x-ns-proxy-autoconfig;
          '';
        };
        locations."= /steam.pac" = {
          return = "301 /proxy.pac";
        };
      };

      "asakiyuki.com" = {
        forceSSL = true;
        enableACME = true;
        globalRedirect = "www.asakiyuki.com";
      };

      "static.asakiyuki.com" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:37284";
        };
      };

      "api.asakiyuki.com" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:5482";
        };
      };

      "inet.asakiyuki.com" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www/wordpress";
        locations."/" = {
          extraConfig = ''
            index index.php index.html;
            try_files $uri $uri/ /index.php$is_args$args;
          '';
        };
        locations."~ \\.php$" = {
          extraConfig = ''
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass unix:/run/phpfpm/wordpress.sock;
            fastcgi_index index.php;
            include ${pkgs.nginx}/conf/fastcgi.conf;
          '';
        };
        locations."~ /\\." = {
          extraConfig = "deny all;";
        };
        locations."~* /(?:uploads|files)/.*\\.php$" = {
          extraConfig = "deny all;";
        };
        locations."~* \\.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$" = {
          extraConfig = ''
            expires max;
            log_not_found off;
          '';
        };
      };

      "adguard.asakiyuki.com" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:34778";
        };
        locations."/dns-query" = {
          proxyPass = "https://127.0.0.1:34780";
          extraConfig = ''
            proxy_ssl_server_name on;
            proxy_ssl_name adguard.asakiyuki.com;
          '';
        };
        locations."= /proxy.pac" = {
          alias = pacFile;
          extraConfig = ''
            default_type application/x-ns-proxy-autoconfig;
          '';
        };
        locations."= /steam.pac" = {
          return = "301 /proxy.pac";
        };
      };

      "git.asakiyuki.com" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:21350";
        };
      };
    };
  };
}
