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
    ${pkgs.mariadb}/bin/mariadb -u mysql -e "CREATE USER IF NOT EXISTS 'wp_user'@'localhost' IDENTIFIED BY '0WWguHrDvhdxyhUq92bx50LcPbG177'; CREATE USER IF NOT EXISTS 'wp_user'@'127.0.0.1' IDENTIFIED BY '0WWguHrDvhdxyhUq92bx50LcPbG177'; GRANT ALL PRIVILEGES ON \`wordpress\`.* TO 'wp_user'@'localhost'; GRANT ALL PRIVILEGES ON \`wordpress\`.* TO 'wp_user'@'127.0.0.1'; FLUSH PRIVILEGES;"
  '';
}
