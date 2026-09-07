{pkgs, ...}: {
  services.nextcloud = {
    enable = true;
    hostName = "drive.asakiyuki.com";

    database.createLocally = false;
    package = pkgs.nextcloud33;

    config = {
      dbhost = "127.0.0.1";
      dbname = "nextcloud";
      dbuser = "nextcloud";
      dbpassFile = "/etc/nextcloud-db-pass";
      adminuser = "admin";
      adminpassFile = "/etc/nextcloud-admin-pass";
      dbtype = "mysql";
    };

    settings = {
      "localstorage.allowsymlinks" = true;
    };
  };
}
