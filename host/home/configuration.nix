{ inputs, pkgs, ... }: {
    # Import Modules
    imports = [
        ./hardware-configuration.nix
        ../../nixos-modules/server/configuration.nix
    ];

    device = {
        admin-email = "vantrong2007vn@gmail.com";
        allow-ssh-users = [ "asakiyuki" "junko" "hoacaclord" ];

        services = {
            ssh.enable = true;
            ssh.port = 15523;

            sql-server.enable = true;
            sql-server.port = 37241;

            lyrics-server.enable = true;
            lyrics-server.port = 28734;

            public-server.enable = true;
            public-server.port = 37284;
            public-server.path = "/home/PUBLIC";

            nginx-proxy-manager.enable = true;
            nginx-proxy-manager.ports = [ 80 18581 443 ];

            ports.allowed.udp = [];
            ports.allowed.tcp = [];
        };
    };

    system.stateVersion = "25.11";
}