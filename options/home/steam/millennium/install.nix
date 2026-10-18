{
  lib,
  config,
  osconfig,
  ...
}:
let
  cfg = config.programs.steam.millennium;
  millenniumEnabled = lib.attrByPath [ "programs" "steam" "millennium" "enable" ] false osconfig;
  stripEmptyAttrs =
    value:
    if builtins.isAttrs value then
      lib.filterAttrs (_: nested: nested != null && nested != { }) (
        lib.mapAttrs (_: stripEmptyAttrs) value
      )
    else
      value;
in
{
  config.home.file = lib.mkIf millenniumEnabled (
    builtins.listToAttrs (
      (map (plugin: {
        name = "${cfg.paths.plugins}/${plugin.pname}";
        value.source = plugin;
      }) cfg.plugins)
      ++ (map (theme: {
        name = "${cfg.paths.themes}/${theme.pname}";
        value.source = theme;
      }) cfg.themes)
      ++ (lib.mapAttrsToList (name: source: {
        name = "${cfg.paths.config}/${name}";
        value.source = source;
      }) cfg.configFiles)
      ++ lib.optionals (cfg.configJson != null) [
        {
          name = "${cfg.paths.config}/config.json";
          value.text = builtins.toJSON (stripEmptyAttrs cfg.configJson);
        }
      ]
      ++ lib.optionals (cfg.css != "") [
        {
          name = "${cfg.paths.config}/quick.css";
          value.text = cfg.css;
        }
      ]
    )
  );
}
