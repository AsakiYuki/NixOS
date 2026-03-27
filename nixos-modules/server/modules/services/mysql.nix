{ pkgs, config, lib, ... }: let 
    cfg = config.device;
in  {
    services.mysql = lib.mkIf cfg.services.sql-server.enable {
        enable = true; 
        package = pkgs.mariadb;
        settings = {
            mysqld = {
                port = cfg.services.sql-server.port;
                bind-address = "0.0.0.0";
            };
        };

        ensureDatabases = [ "main_db" ];
        ensureUsers = [
            {
                name = "admin";
                ensurePermissions = { "*.*" = "ALL PRIVILEGES"; };
            }
        ];

        replication = {
            masterPort = cfg.services.sql-server.port;
        };
    };
}