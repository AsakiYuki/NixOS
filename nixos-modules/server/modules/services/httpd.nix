{ config, lib, ... }: let 
    cfg = config.device;
in  {
    services.httpd = lib.mkIf cfg.public-server.enable {
        enable = true;
        adminAddr = cfg.admin-email;

        user = "static";
        group = "public";

        virtualHosts = {
            localhost = {
                documentRoot = cfg.public-server.path;

                listen = [
                    { ip = "0.0.0.0"; port = cfg.public-server.port; }
                ];

                extraConfig = ''
                    <Directory "${cfg.public-server.path}">
                        Options -Indexes +FollowSymLinks
                        AllowOverride None
                        Require all granted

                        <LimitExcept GET HEAD OPTIONS>
                            Require all denied
                        </LimitExcept>
                    </Directory>
                '';
            };
        };
    }
}