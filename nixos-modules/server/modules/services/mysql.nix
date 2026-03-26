{ pkgs, ... }: let 
    GLOBAL = import ../../_global.nix;
in {
    enable = true; 
    package = pkgs.mariadb;
    settings = {
        mysqld = {
            port = GLOBAL.SQL_SERVER_PORT;
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
        masterPort = GLOBAL.SQL_SERVER_PORT;
    };
}