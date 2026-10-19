{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.cider-mv-resolver;
in
{
  options.programs.cider-mv-resolver = {
    enable = lib.mkEnableOption "Cider MV Resolver";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.cider-mv-resolver;
      defaultText = lib.literalExpression "pkgs.cider-mv-resolver";
      description = "The Cider MV Resolver package to install and run.";
    };
  };

  config = lib.mkIf cfg.enable (
    {
      home.packages = [ cfg.package ];
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux {
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
    }
  );
}
