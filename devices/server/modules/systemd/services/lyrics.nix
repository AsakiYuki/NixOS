{ pkgs }: let 
    import GLOBAL = import ../../../_global.nix;
in {
    enable = true;
    description = "A self-host musixmatch lyrics service";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
        ExecStart = "npm run start";
        WorkingDirectory = "/home/asakiyuki/host/musixmatch-db";
        Restart = "always";
        User = "asakiyuki";
    };
}