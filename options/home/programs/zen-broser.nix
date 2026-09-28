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
    extension-settings = {
      override = lib.mkOption {
        default = [];
        type = lib.types.listOf (lib.types.submodule {
          options = {
            package = lib.mkOption {
              type = lib.types.package;
            };
            settings = lib.mkOption {
              type = lib.types.attrsOf lib.types.anything;
              default = {};
            };
          };
        });
      };
    };
  };

  config.programs.zen-browser = lib.mkIf cfg.enable {
    policies = {
      ExtensionSettings = lib.listToAttrs (map (addon: {
          name = addon.meta.addonid;
          value.private_browsing = true;
        })
        cfg.private-browsing-extension-packages);

      "3rdparty".Extensions = lib.listToAttrs (map ({
          package,
          settings,
        }: {
          name = package.meta.addonid;
          value.toOverwrite = settings;
        })
        cfg.extension-settings.override);
    };
  };
}
