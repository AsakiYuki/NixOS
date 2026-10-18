{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.steam;
in
{
  options.programs.steam = {
    allowSteamlinkPorts = lib.mkEnableOption "steam-link streaming ports";
    allowMultiplayerPorts = lib.mkEnableOption "Steam multiplayer and voice ports";

    millennium = lib.mkOption {
      default = { };
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "Millennium for Steam";

          package = lib.mkOption {
            type = lib.types.package;
            default = pkgs.millennium-steam;
            defaultText = lib.literalExpression "pkgs.millennium-steam";
            description = "Steam package with Millennium enabled.";
          };
        };
      };
      description = "Millennium integration for Steam.";
    };
  };

  config.programs.steam.package = lib.mkIf cfg.millennium.enable cfg.millennium.package;

  config.networking.firewall = {
    allowedTCPPorts = lib.mkIf cfg.allowSteamlinkPorts [
      27036
      27037
    ];
    allowedUDPPorts =
      (lib.optionals cfg.allowSteamlinkPorts [
        27031
        27032
        27033
        27034
        27035
        27036
      ])
      ++ (lib.optionals cfg.allowMultiplayerPorts [
        4380
        3478
        4379
      ]);
  };
}
