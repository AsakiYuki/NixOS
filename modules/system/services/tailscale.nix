{
  lib,
  config,
  ...
}: let
  cfg = config.services.tailscale;
in
  lib.mkIf (cfg.enable && (!cfg.disable-agenix-secrets)) {
    services.tailscale = {
      authKeyFile = config.age.secrets.tailscale.path;
    };
  }
