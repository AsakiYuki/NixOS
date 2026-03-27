{ lib, pkgs, ... }: {
    options.device.services = {
        ssh = {
            enable = lib.mkEnableOption "ssh";
            port = lib.mkOption {
                type = lib.types.port;
                default = 22;
                description = "openssh port";
            };
            allowed-users = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ "asakiyuki" ];
                description = "list of allowed ssh users";
            };
        };

        minecraft-server = {
            enable = lib.mkEnableOption "minecraft server";
            server-welcome = lib.mkOption {
                type = lib.types.str;
                default = "The Asa's Craft!";
                description = "minecraft server motd";
            };
            difficulty = lib.mkOption {
                type = lib.types.str;
                default = "normal";
                description = "minecraft server motd";
            };
            gamemode = lib.mkOption {
                type = lib.types.str;
                default = "survival";
                description = "minecraft server motd";
            };
            max-players = lib.mkOption {
                type = lib.types.int;
                default = 5;
                description = "minecraft server max players";
            };
            package = lib.mkOption {
                type = lib.types.package;
                default = pkgs.vanillaServers.vanilla-26_1;
                description = "minecraft server package";
            };
            data-dir = lib.mkOption {
                type = lib.types.str;
                default = "/var/minecraft-servers";
                description = "minecraft server data dir";
            };
            java-opts = lib.mkOption {
                type = lib.types.str;
                default = "-Xmx4G -Xms2G";
                description = "java options";
            };
            port = lib.mkOption {
                type = lib.types.port;
                default = 25565;
                description = "minecraft server port";
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
}