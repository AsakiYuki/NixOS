{ pkgs }: let 
    GLOBAL = import ../../../_global.nix;
in {
    enable = true;
    description = "A self-host musixmatch lyrics service";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
        ExecStart = "${pkgs.nix}/bin/nix develop -c node dist/app.js";
        WorkingDirectory = "/home/asakiyuki/HOST/musixmatch-db";
        Restart = "always";
        User = "asakiyuki";
    };
}