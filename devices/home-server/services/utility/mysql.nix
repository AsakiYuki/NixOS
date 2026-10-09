{pkgs, lib, ...}: {
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;

    ensureDatabases = [
      "wordpress"
    ];

    ensureUsers = [
      {
        name = "wordpress";
        ensurePermissions = {
          "wordpress.*" = "ALL PRIVILEGES";
        };
      }
      {
        name = "asakiyuki";
        ensurePermissions = {
          "wordpress.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  systemd.services.mysql.postStart = lib.mkAfter ''
    ${pkgs.mariadb}/bin/mariadb -u mysql -e "ALTER USER IF EXISTS 'asakiyuki'@'localhost' IDENTIFIED VIA unix_socket; GRANT ALL PRIVILEGES ON wordpress.* TO 'asakiyuki'@'localhost'; FLUSH PRIVILEGES;"
  '';
}
