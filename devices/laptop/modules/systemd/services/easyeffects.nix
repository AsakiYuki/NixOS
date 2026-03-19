{ pkgs, ... }: {
    systemd.user.services.easyeffects = {
        description = "Auto start EasyEffects";
        wantedBy = [ "default.target" ];
        serviceConfig = {
            ExecStart = "${pkgs.easyeffects}/bin/easyeffects --service-mode";
            Restart = "on-failure";
        };
    };
}