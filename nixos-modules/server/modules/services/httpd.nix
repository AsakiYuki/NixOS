{ config, lib, ... }: let 
    cfg = config.device;
in  {
    services.httpd = lib.mkIf cfg.services.public-server.enable {
        enable = true;
        adminAddr = cfg.admin-email;

        user = "static";
        group = "public";

        virtualHosts = {
            localhost = {
                documentRoot = cfg.services.public-server.path;

                listen = [
                    { ip = "0.0.0.0"; port = cfg.services.public-server.port; }
                ];

                extraConfig = ''
                    <Directory "${cfg.services.public-server.path}">
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
    };
}