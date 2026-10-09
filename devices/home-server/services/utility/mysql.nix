{
  pkgs,
  lib,
  ...
}: {
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;

    ensureDatabases = [
      "wordpress"
    ];
  };

  systemd.services.mysql.postStart = lib.mkAfter ''
    ${pkgs.mariadb}/bin/mariadb -u mysql -e "CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY '12345678'; ALTER USER 'admin'@'localhost' IDENTIFIED BY '12345678'; CREATE USER IF NOT EXISTS 'admin'@'127.0.0.1' IDENTIFIED BY '12345678'; ALTER USER 'admin'@'127.0.0.1' IDENTIFIED BY '12345678'; GRANT ALL PRIVILEGES ON \`wordpress\`.* TO 'admin'@'localhost'; GRANT ALL PRIVILEGES ON \`wordpress\`.* TO 'admin'@'127.0.0.1'; FLUSH PRIVILEGES;"
  '';
}
