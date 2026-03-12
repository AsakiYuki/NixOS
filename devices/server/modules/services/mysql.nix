{ pkgs, ... }: let 
    GLOBAL = import ../../_global.nix;
in {
    enable = true;
    package = pkgs.mariadb;
    replication = {
        masterPort = GLOBAL.SQL_SERVER_PORT;
    };
}