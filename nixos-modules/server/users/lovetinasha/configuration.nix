{ pkgs, lib, ... }: {
     imports = [
          ./programs/_programs.nix
     ];

     home = {
          username = "lovetinasha";
          stateVersion = "25.11";
     };
}
