{pkgs, ...}: {
  systemd.services.dawncraft = {
    description = "Dawncraft Host Server";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];

    path = [pkgs.zulu17 pkgs.screen];

    serviceConfig = {
      User = "asakiyuki";
      WorkingDirectory = "/mnt/HOST/rlcraft";
      ExecStart = "${pkgs.screen}/bin/screen -DmS rlcraft ${pkgs.zulu17}/bin/java -Xms8G -Xmx8G -jar forge.jar nogui";
      ExecStop = "${pkgs.runtimeShell} -c '${pkgs.screen}/bin/screen -S rlcraft -X stuff \"save-all\\n\" ; sleep 5; ${pkgs.screen}/bin/screen -S rlcraft -X stuff \"stop\\n\" ; while ${pkgs.screen}/bin/screen -list | grep -q rlcraft; do sleep 1; done'";
      TimeoutStopSec = "2min";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}
