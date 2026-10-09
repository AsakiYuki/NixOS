{...}: {
  services.wordpress = {
    webserver = "nginx";
    sites."inet.asakiyuki.com" = {
      settings = {
        AUTOMATIC_UPDATER_DISABLED = true;
        WP_HOME = "https://inet.asakiyuki.com";
        WP_SITEURL = "https://inet.asakiyuki.com";
      };
    };
  };
}
