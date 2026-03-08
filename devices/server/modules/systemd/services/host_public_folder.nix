{ pkgs, ... }: let 
    GLOBAL = import ../../../../../global/global.nix;
in {
    enable = true;
    description = "Open Public folder to internet!";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
        ExecStart = "${pkgs.python3}/bin/python3 -m http.server ${builtins.toString GLOBAL.SERVER.PUBLIC_FOLDERS.PORT}";
        WorkingDirectory = GLOBAL.SERVER.PUBLIC_FOLDERS.PATH;
        Restart = "always";
        User = "asakiyuki";
    };
}