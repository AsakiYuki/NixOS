{ pkgs, ... }: {
    systemd.services.vicinae = {
        description = "Auto start Vicinae";
        wantedBy = [ "default.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.vicinae}/bin/vicinae";
            Restart = "on-failure";
            User = "asakiyuki";
        };
    };
}