{ pkgs, ... }: {
    systemd.services.easyeffects = {
        enable = true;
        description = "Auto start EasyEffects";
        wantedBy = [ "graphical.target" ];
        after = [ "graphical.target" ];
        serviceConfig = {
            ExecStart = "${pkgs.easyeffects}/bin/nix";
            Restart = "on-failure";
            User = "asakiyuki";
            Environment = "DISPLAY=:0";
        };
    };
}