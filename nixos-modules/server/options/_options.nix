{ lib, config, ... }: {
    options.device = {
        admin-email = lib.mkOption {
            type = lib.types.str;
            default = "vantrong2007vn@gmail.com";
            description = "admin email for git";
        };
        allow-ssh-users = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ "asakiyuki" ];
            description = "list of allowed ssh users";
        };
        
        services = {
            ssh = {
                enable = lib.mkEnableOption "ssh";
                port = lib.mkOption {
                    type = lib.types.port;
                    default = 22;
                    description = "openssh port";
                };
            };

            sql-server = {
                enable = lib.mkEnableOption "sql server";
                port = lib.mkOption {
                    type = lib.types.port;
                    default = 1433;
                    description = "sql server port";
                };
            };

            lyrics-server = {
                enable = lib.mkEnableOption "lyrics server";
                port = lib.mkOption {
                    type = lib.types.port;
                    default = 28734;
                    description = "sql server port";
                };
            };

            public-server = {
                enable = lib.mkEnableOption "public server";
                path = lib.mkOption {
                    type = lib.types.str;
                    default = "/home/PUBLIC";
                    description = "public path";
                };
                port = lib.mkOption {
                    type = lib.types.port;
                    default = 37284;
                    description = "public server";
                };
            };

            nginx-proxy-manager = {
                enable = lib.mkEnableOption "nginx proxy manager";
                ports = lib.mkOption {
                    type = lib.types.listOf lib.types.port;
                    default = [ 80 81 443 ];
                    description = "nginx proxy manager";
                };
            };

            ports = {
                allowed = {
                    udp = lib.mkOption {
                        type = lib.types.listOf lib.types.port;
                        default = [];
                        description = "allowed udp port";
                    };
                    tcp = lib.mkOption {
                        type = lib.types.listOf lib.types.port;
                        default = [];
                        description = "allowed tcp port";
                    };
                };
            };
        };
    };
}