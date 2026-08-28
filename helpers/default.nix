{...} @ args: let
  fs = import ./fileSystem.nix;
  mkAuthKeys = import ./mkAuthorizedKeys.nix;
  mkProgOpt = import ./mkProgramOption.nix args;
  helpers = import ./helpers.nix args;
  attrs = {
    mkUsers = import ./mkUsers.nix args;
  };
  catppuccin = import ./catppuccin.nix;
in
  fs // mkAuthKeys // mkProgOpt // attrs // helpers // {inherit catppuccin;}
