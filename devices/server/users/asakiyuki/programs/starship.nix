{ ... }: let
  defaultStarship = import ../../../../../global/programs/starship.nix {};
in {
    programs.starship = {
        enable = true;
        settings = defaultStarship.settings;
    };
}