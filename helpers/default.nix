{...} @ args: let
  fs = import ./fileSystem.nix;
  mkAuthKeys = import ./mkAuthorizedKeys.nix;
  mkProgOpt = import ./mkProgramOption.nix args;
  attrs = {
    mkUsers = import ./mkUsers.nix args;
  };
  catppuccin = import ./catppuccin.nix;
in
  fs // mkAuthKeys // mkProgOpt // attrs // {inherit catppuccin;}
