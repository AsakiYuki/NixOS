{ libs, ... }: let
  defaultStarship = import (libs.root "/common/programs/starship.nix") {};
in {
    programs.starship = {
        enable = true;
        settings = defaultStarship.settings;
    };
}