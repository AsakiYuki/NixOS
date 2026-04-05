{
  pkgs,
  config,
  lib,
  ...
}:
{
  systemd.services.lyrics = lib.mkIf config.device.services.lyrics-server.enable {
    enable = false;
    description = "A self-host musixmatch lyrics service";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.nix}/bin/nix develop -c node dist/app.js";
      WorkingDirectory = "/home/asakiyuki/HOST/musixmatch-db";
      Restart = "always";
      User = "asakiyuki";
    };
  };
}

