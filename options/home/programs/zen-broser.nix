{
  config,
  lib,
  ...
}: let
  cfg = config.programs.zen-browser;
in {
  options.programs.zen-browser = {
    private-browsing-extension-packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
    };
  };

  config.programs.zen-browser = lib.mkIf cfg.enable {
    policies.ExtensionSettings = lib.listToAttrs (map (addon: {
        name = addon.meta.addonid;
        value.private_browsing = true;
      })
      cfg.private-browsing-extension-packages);
  };
}
