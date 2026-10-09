{pkgs, ...}: {
  systemd.services.wordpress = {
    description = "WordPress Web Server";
    wantedBy = ["multi-user.target"];
    after = ["network.target" "mysql.service"];

    path = [pkgs.php];

    serviceConfig = {
      User = "asakiyuki";
      WorkingDirectory = "/mnt/HOST/wordpress";
      ExecStart = "${pkgs.php}/bin/php -S 127.0.0.1:3367 router.php";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
