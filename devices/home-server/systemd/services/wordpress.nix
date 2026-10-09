{pkgs, ...}: {
  systemd.services.wordpress-setup = {
    description = "Setup standalone WordPress in /var/www/wordpress";
    wantedBy = ["multi-user.target"];
    before = ["phpfpm-wordpress.service"];
    after = ["network-online.target" "mysql.service"];
    wants = ["network-online.target"];

    path = with pkgs; [
      curl
      gnutar
      gzip
      unzip
      coreutils
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      set -e
      mkdir -p /var/www/wordpress

      if [ ! -f /var/www/wordpress/index.php ]; then
        echo "Downloading and extracting latest WordPress..."
        curl -sSL https://wordpress.org/latest.tar.gz | tar -xzf - --strip-components=1 -C /var/www/wordpress
      fi

      if [ -d /var/lib/wordpress/inet.asakiyuki.com/uploads ] && [ ! -d /var/www/wordpress/wp-content/uploads ]; then
        echo "Migrating existing uploads..."
        mkdir -p /var/www/wordpress/wp-content/uploads
        cp -rn /var/lib/wordpress/inet.asakiyuki.com/uploads/* /var/www/wordpress/wp-content/uploads/ || true
      fi

      if [ ! -f /var/www/wordpress/wp-config.php ]; then
        echo "Generating wp-config.php..."
        {
          echo "<?php"
          echo "define( 'DB_NAME', 'wordpress' );"
          echo "define( 'DB_USER', 'wordpress' );"
          echo 'define( "DB_PASSWORD", "" );'
          echo "define( 'DB_HOST', 'localhost' );"
          echo 'define( "DB_CHARSET", "utf8mb4" );'
          echo 'define( "DB_COLLATE", "" );'
          echo "define( 'FS_METHOD', 'direct' );"
          echo "define( 'WP_HOME', 'https://inet.asakiyuki.com' );"
          echo "define( 'WP_SITEURL', 'https://inet.asakiyuki.com' );"
        } > /var/www/wordpress/wp-config.php

        curl -s https://api.wordpress.org/secret-key/1.1/salt/ >> /var/www/wordpress/wp-config.php || true

        {
          echo "\$table_prefix = 'wp_';"
          echo "define( 'WP_DEBUG', false );"
          echo "if ( ! defined( 'ABSPATH' ) ) { define( 'ABSPATH', __DIR__ . '/' ); }"
          echo "require_once ABSPATH . 'wp-settings.php';"
        } >> /var/www/wordpress/wp-config.php
      fi

      chown -R wordpress:nginx /var/www/wordpress
      chmod -R 775 /var/www/wordpress
      if [ -f /var/www/wordpress/wp-config.php ]; then
        chmod 660 /var/www/wordpress/wp-config.php
      fi

      echo "WordPress setup complete."
    '';
  };
}
