{unstable-pkgs, ...}: {
  services.wordpress = {
    webserver = "nginx";
    sites."inet.asakiyuki.com" = {
      package = unstable-pkgs.wordpress;
      database = {
        name = "wordpress";
        user = "wordpress";
        createLocally = true;
      };
      settings = {
        DISALLOW_FILE_MODS = true;
        AUTOMATIC_UPDATER_DISABLED = true;
        WP_HOME = "https://inet.asakiyuki.com";
        WP_SITEURL = "https://inet.asakiyuki.com";
      };
    };
  };
}
