{pkgs, ...}: let
  prepareWordpressDirectory = pkgs.writeShellScript "prepare-wordpress-directory" ''
    set -euo pipefail

    ${pkgs.coreutils}/bin/chown -R wordpress:wordpress /mnt/HOST/wordpress
    ${pkgs.acl}/bin/setfacl -R -m u:asakiyuki:rwX /mnt/HOST/wordpress
    ${pkgs.findutils}/bin/find /mnt/HOST/wordpress -type d \
      -exec ${pkgs.acl}/bin/setfacl -m d:u:asakiyuki:rwx {} +
  '';
in {
  systemd.services.wordpress-permissions = {
    before = ["wordpress.service"];
    requiredBy = ["wordpress.service"];
    requires = ["mnt-HOST.mount"];
    after = ["mnt-HOST.mount"];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = prepareWordpressDirectory;
    };
  };

  systemd.services.wordpress = {
    description = "WordPress Web Server";
    wantedBy = ["multi-user.target"];
    after = ["network.target" "mysql.service" "mnt-HOST.mount" "wordpress-permissions.service"];
    requires = ["mnt-HOST.mount" "wordpress-permissions.service"];

    path = [pkgs.php85];

    serviceConfig = {
      User = "wordpress";
      Group = "wordpress";
      WorkingDirectory = "/mnt/HOST/wordpress";
      ExecStart = "${pkgs.php85}/bin/php -S 127.0.0.1:3367 router.php";
      Restart = "on-failure";
      RestartSec = "5s";

      CapabilityBoundingSet = "";
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      TemporaryFileSystem = ["/mnt/HOST"];
      BindPaths = ["/mnt/HOST/wordpress"];
      ReadWritePaths = ["/mnt/HOST/wordpress"];
      RestrictAddressFamilies = ["AF_INET" "AF_INET6" "AF_UNIX"];
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      UMask = "0077";
      LockPersonality = true;
    };
  };
}
