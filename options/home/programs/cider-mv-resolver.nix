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
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
