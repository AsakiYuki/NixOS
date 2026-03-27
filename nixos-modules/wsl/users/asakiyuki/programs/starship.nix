{ ... }: let
  defaultStarship = import (asa-lib.root "/common/programs/starship.nix") {};
in {
  programs.starship = {
    enable = true;
    settings = defaultStarship.settings;
  };
}