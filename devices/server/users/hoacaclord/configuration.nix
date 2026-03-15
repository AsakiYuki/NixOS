{ pkgs, lib, ... }: {
     imports = [
          ./programs/_programs.nix
     ];

     home = {
          username = "junko";
          stateVersion = "25.11";
     };
}
