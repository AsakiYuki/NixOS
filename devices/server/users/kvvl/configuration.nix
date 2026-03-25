{ pkgs, lib, ... }: {
     imports = [
          ./programs/_programs.nix
     ];

     home = {
          username = "kvvl";
          stateVersion = "25.11";
     };
}
