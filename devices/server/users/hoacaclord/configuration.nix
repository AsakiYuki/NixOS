{ pkgs, lib, ... }: {
     imports = [
          ./programs/_programs.nix
     ];

     home = {
          username = "hoacaclord";
          stateVersion = "25.11";
     };
}
