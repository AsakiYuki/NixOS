{ lib, ... }:
{
  options = {
    configFiles = lib.mkOption {
      type = with lib.types; attrsOf (either path package);
      default = { };
      description = ''
        Files to link into programs.steam.millennium.paths.config. Millennium
        does not define a universal settings schema, so each file is supplied
        as a path or package.
      '';
    };

    configJson = lib.mkOption {
      default = null;
      type = lib.types.nullOr (
        lib.types.submodule {
          options = {
            general = lib.mkOption {
              default = { };
              type = lib.types.submodule {
                options = {
                  accentColor = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                  };
                  checkForMillenniumUpdates = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                  };
                  checkForPluginAndThemeUpdates = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                  };
                  injectCSS = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                  };
                  injectJavascript = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                  };
                  millenniumUpdateChannel = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                  };
                  onMillenniumUpdate = lib.mkOption {
                    type = lib.types.nullOr lib.types.int;
                    default = null;
                  };
                  shouldShowThemePluginUpdateNotifications = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                  };
                };
              };
            };

            misc = lib.mkOption {
              default = { };
              type = lib.types.submodule {
                options.hasShownWelcomeModal = lib.mkOption {
                  type = lib.types.nullOr lib.types.bool;
                  default = null;
                };
              };
            };

            network = lib.mkOption {
              default = { };
              type = lib.types.submodule {
                options = {
                  proxy = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                  };
                  proxyPassword = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                  };
                  proxyUsername = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                  };
                };
              };
            };

            notifications = lib.mkOption {
              default = { };
              type = lib.types.submodule {
                options = {
                  showNotifications = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                  };
                  showPluginNotifications = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                  };
                  showUpdateNotifications = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                  };
                };
              };
            };

            plugins = lib.mkOption {
              default = { };
              type = lib.types.submodule {
                options.enabledPlugins = lib.mkOption {
                  type = lib.types.nullOr (lib.types.listOf lib.types.str);
                  default = null;
                };
              };
            };

            themes = lib.mkOption {
              default = { };
              type = lib.types.submodule {
                options = {
                  activeTheme = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                  };
                  allowedScripts = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                  };
                  allowedStyles = lib.mkOption {
                    type = lib.types.nullOr lib.types.bool;
                    default = null;
                  };
                  conditions = lib.mkOption {
                    type = lib.types.nullOr (lib.types.attrsOf (lib.types.attrsOf lib.types.str));
                    default = null;
                  };
                  themeColors = lib.mkOption {
                    type = lib.types.nullOr (lib.types.attrsOf (lib.types.attrsOf lib.types.str));
                    default = null;
                  };
                };
              };
            };
          };
        }
      );
      example = {
        general.checkForMillenniumUpdates = true;
        plugins.enabledPlugins = [ "some-plugin" ];
        themes.activeTheme = "Steam";
      };
      description = ''
        Typed Millennium config.json settings. Theme condition and color maps
        accept arbitrary theme and setting names, with string values.
      '';
    };
  };
}
