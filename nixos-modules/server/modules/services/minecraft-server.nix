{ pkgs, ... }: {
    nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
    services.minecraft-servers = {
        enable = true;
        eula = true;
        openFirewall = true;
        dataDir = "/home/asakiyuki/HOST/minecraft-servers";
        servers.vanilla = {
            enable = true;
            autoStart = true;
            enableReload = true;
            jvmOpts = "-Xmx4G -Xms2G";
            package = pkgs.minecraftServers.vanilla-server;
            
            serverProperties = {
                server-port = 43000;
                difficulty = 3;
                gamemode = 1;
                max-players = 10;
                motd = "The Asa's Craft!";
                white-list = true;
                # enable-rcon = true;
                # "rcon.password" = "hunter2";
            };
        };
    };
}