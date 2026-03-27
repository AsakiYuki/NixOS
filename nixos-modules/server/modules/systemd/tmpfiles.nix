{ config, libs, ... }: let 
    cfg = config.device;
in  {
    systemd.tmpfiles = {
        rules = [
            "d /home/MEDIA_FILES 2775 asakiyuki public - -"
            "L+ /home/asakiyuki/MEDIA_FILES - - - - /home/MEDIA_FILES"
            "L+ /home/junko/MEDIA_FILES - - - - /home/MEDIA_FILES"
        ]
        ++ (
            libs.mkIfElse cfg.services.public-server.enable [ "d ${cfg.services.public-server.path} 2775 asakiyuki public - -" "L+ /home/asakiyuki/PUBLIC - - - - ${cfg.services.public-server.path}" "L+ /home/junko/PUBLIC - - - - ${cfg.services.public-server.path}" ] []
        );
    };
}