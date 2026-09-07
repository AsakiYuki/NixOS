{...}: {
  services.httpd = {
    enable = true;
    enablePHP = true;
    adminAddr = "vantrong2007vn@gmail.com";

    user = "static";
    group = "public";

    virtualHosts = {
      localhost = {
        documentRoot = "/home/PUBLIC";
        listen = [
          {
            ip = "0.0.0.0";
            port = 37284;
          }
        ];
        extraConfig = ''
          <Directory "/home/PUBLIC">
              Options -Indexes +FollowSymLinks
              AllowOverride None
              Require all granted

              <LimitExcept GET HEAD OPTIONS>
                  Require all denied
              </LimitExcept>
          </Directory>
        '';
      };
    };
  };
}
