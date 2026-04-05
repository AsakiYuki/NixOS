{ lib, ... }:
{
  imports = [ ./services.nix ];

  options.device = {
    flake-name = lib.mkOption {
      type = lib.types.str;
      default = "desktop";
      description = "Flake name for quick rebuild";
    };

    cursors = lib.mkOption {
      type = lib.types.str;
      default = "aemeath";
      description = "Cursor theme to use for the desktop";
    };
  };
}

