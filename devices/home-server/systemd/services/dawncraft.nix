{pkgs, ...}: {
  systemd.services.dawncraft = {
    description = "Dawncraft Host Server";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];

    path = [pkgs.zulu17 pkgs.screen];

    serviceConfig = {
      User = "asakiyuki";
      WorkingDirectory = "/mnt/HOST/dawncraft";
      ExecStart = "${pkgs.screen}/bin/screen -DmS dawncraft ${pkgs.runtimeShell} ./run.sh nogui";
      ExecStop = "${pkgs.runtimeShell} -c '${pkgs.screen}/bin/screen -S dawncraft -X stuff \"save-all\\n\" ; sleep 5; ${pkgs.screen}/bin/screen -S dawncraft -X stuff \"stop\\n\" ; while ${pkgs.screen}/bin/screen -list | grep -q dawncraft; do sleep 1; done'";
      TimeoutStopSec = "2min";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}
