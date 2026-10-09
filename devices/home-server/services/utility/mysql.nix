{pkgs, ...}: {
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
    ];
  };
}
