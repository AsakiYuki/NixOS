{
  pkgs,
  unstable-pkgs,
  ...
}: let
  hideNagPlugin = pkgs.writeText "hide-update-nag.php" ''
    <?php
    add_action('admin_head', function () {
        remove_action('admin_notices', 'update_nag', 3);
    });
    add_filter('pre_site_transient_update_core', '__return_null');
  '';
in {
  services.wordpress = {
    webserver = "nginx";
    sites."inet.asakiyuki.com" = {
      package = unstable-pkgs.wordpress.overrideAttrs (old: {
        postInstall =
          (old.postInstall or "")
          + ''
            rm -rf $out/share/wordpress/wp-content/plugins
            ln -s /var/lib/wordpress/inet.asakiyuki.com/plugins $out/share/wordpress/wp-content/plugins
          '';
      });
      database = {
        name = "wordpress";
        user = "wordpress";
        createLocally = true;
      };
      extraConfig = ''
        define('WPMU_PLUGIN_DIR', '/var/lib/wordpress/inet.asakiyuki.com/mu-plugins');
      '';
      settings = {
        AUTOMATIC_UPDATER_DISABLED = true;
        WP_HOME = "https://inet.asakiyuki.com";
        WP_SITEURL = "https://inet.asakiyuki.com";
        FS_METHOD = "direct";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d '/var/lib/wordpress/inet.asakiyuki.com/plugins' 0750 wordpress nginx - -"
    "Z '/var/lib/wordpress/inet.asakiyuki.com/plugins' 0750 wordpress nginx - -"
    "d '/var/lib/wordpress/inet.asakiyuki.com/mu-plugins' 0750 wordpress nginx - -"
    "Z '/var/lib/wordpress/inet.asakiyuki.com/mu-plugins' 0750 wordpress nginx - -"
    "C+ '/var/lib/wordpress/inet.asakiyuki.com/mu-plugins/hide-nag.php' 0644 wordpress nginx - ${hideNagPlugin}"
  ];
}
