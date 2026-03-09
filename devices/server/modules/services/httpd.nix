{ ... }: let
    GLOBAL = import ../../../../global/global.nix;
in {
    enable = true;
    adminAddr = GLOBAL.ADMIN_EMAIL;

    user = "static";
    group = "static";

    virtualHosts = {
        localhost = {
            documentRoot = GLOBAL.SERVER.PUBLIC_FOLDERS.PATH;

            listen = [
                { ip = "0.0.0.0"; port = GLOBAL.SERVER.PUBLIC_FOLDERS.PORT; }
            ];

            extraConfig = ''
                <Directory "${GLOBAL.SERVER.PUBLIC_FOLDERS.PATH}">
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
}