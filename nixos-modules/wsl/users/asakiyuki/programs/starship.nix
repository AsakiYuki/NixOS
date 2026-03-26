{ ... }: let
  defaultStarship = import ../../../../../common/programs/starship.nix {};
in {
  programs.starship = {
    enable = true;
    settings = defaultStarship.settings;
  };
}