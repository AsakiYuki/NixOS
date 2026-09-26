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
              Options +Indexes +FollowSymLinks
              AllowOverride None
              Require all granted

              IndexOptions FancyIndexing VersionSort HTMLTable NameWidth=* FoldersFirst Charset=UTF-8
              IndexIgnoreReset ON

              <FilesMatch ".*">
                  Require all granted
              </FilesMatch>

              <LimitExcept GET HEAD OPTIONS>
                  Require all denied
              </LimitExcept>
          </Directory>
        '';
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /home/PUBLIC 2775 static public - -"
    "a+ /home/PUBLIC - - - - d:g::rwx,d:o::r-x,g::rwx,o::r-x"
  ];
}
