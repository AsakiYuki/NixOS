{
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.programs.cider-mv-resolver;
in
{
  config = lib.mkIf (cfg.enable && lib.hasAttrByPath [ "systemd" "user" "services" ] options) {
    systemd.user.services.cider-mv-resolver = {
      Unit = {
        Description = "Cider MV Resolver companion service";
        After = [ "network.target" ];
      };
      Service = {
        ExecStart = "${cfg.package}/bin/cider-mv-resolver";
        Environment = [
          "CIDER_MV_RESOLVER_YT_DLP=${cfg.package}/bin/cider-mv-resolver-yt-dlp"
          "CIDER_MV_RESOLVER_YT_DLP_REAL=${config.programs.yt-dlp.package}/bin/yt-dlp"
          "CIDER_MV_RESOLVER_YT_DLP_CONFIG=${config.xdg.configHome}/yt-dlp/config"
        ];
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
