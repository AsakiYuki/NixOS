{
  osconfig ? {},
  lib,
  ...
}: let
  t = lib.attrByPath ["device" "theme" "catppuccin"] {} osconfig;
  catppuccin = builtins.trace (builtins.toJSON t) t;
in {
  options.theme = {
    catppuccin = {
      flavour = lib.mkOption {
        type = lib.types.enum (lib.attrNames lib.catppuccin);
        default = catppuccin.flavour or "mocha";
        description = "catppuccin flavour colors";
      };
      accent = lib.mkOption {
        type = lib.types.enum ["rosewater" "flamingo" "pink" "mauve" "red" "maroon" "peach" "yellow" "green" "teal" "sky" "sapphire" "blue" "lavender"];
        default = catppuccin.accent or "pink";
        description = "catppuccin accent color";
      };
      accent-2 = lib.mkOption {
        type = lib.types.enum ["rosewater" "flamingo" "pink" "mauve" "red" "maroon" "peach" "yellow" "green" "teal" "sky" "sapphire" "blue" "lavender"];
        default = catppuccin.accent-2 or "mauve";
        description = "catppuccin accent color";
      };
    };
  };
}
