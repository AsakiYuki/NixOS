{ inputs, pkgs, config, lib, ... }: let 
    cfg = config.services.device.minecraft-server;
in  {
    nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
    services.minecraft-servers = lib.mkIf cfg.enable {
        enable = true;
        eula = true;
        openFirewall = true;
        dataDir = cfg.data-dir;
        servers.vanilla = {
            enable = true;
            autoStart = true;
            enableReload = true;
            jvmOpts = cfg.java-opts;
            package = cfg.package;
            
            serverProperties = {
                server-port = cfg.port;
                difficulty = cfg.difficulty;
                gamemode = cfg.gamemode;
                max-players = cfg.max-players;
                motd = cfg.server-welcome;
            };
        };
    };
}