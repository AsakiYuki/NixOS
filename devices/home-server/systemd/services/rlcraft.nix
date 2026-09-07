{pkgs, ...}: {
  systemd.services.rlcraft = {
    description = "RLCraft Host Server";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];

    path = [pkgs.zulu8];

    serviceConfig = {
      User = "asakiyuki";
      WorkingDirectory = "/mnt/HOST/rlcraft";
      ExecStart = "${pkgs.zulu8}/bin/java -Xms8G -Xmx8G -jar forge.jar nogui";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}
