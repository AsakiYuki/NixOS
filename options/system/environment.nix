{lib, ...}: {
  options.device = {
    theme = {
      catppuccin = {
        flavor = lib.mkOption {
          type = lib.types.enum (lib.attrNames lib.catppuccin);
          default = "mocha";
          description = "catppuccin flavor colors";
        };
        accent = lib.mkOption {
          type = lib.types.enum ["rosewater" "flamingo" "pink" "mauve" "red" "maroon" "peach" "yellow" "green" "teal" "sky" "sapphire" "blue" "lavender"];
          default = "pink";
          description = "catppuccin accent color";
        };
      };
    };

    dm = {
      sddm = {
        enable = lib.mkEnableOption "sddm";
        theme = lib.mkOption {
          type = lib.types.str;
          default = "hyprland_kath";
          description = "astronaut theme name";
        };
      };

      gdm.enable = lib.mkEnableOption "gdm";
    };

    de = {
      kdePlasma.enable = lib.mkEnableOption "kde plasma";
      gnome.enable = lib.mkEnableOption "gnome";
    };

    wm = {
      niri.enable = lib.mkEnableOption "niri";
      hyprland = {
        enable = lib.mkEnableOption "hyprland";

        extraConfig = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Extra Hyprland configuration to be appended to the generated config.";
        };
      };
    };
  };
}
