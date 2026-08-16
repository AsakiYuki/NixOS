{nixpkgs, ...}: let
  pkgs = import nixpkgs {system = "x86_64-linux";};
in {
  devShells.x86_64-linux.default = pkgs.mkShell {
    shellHook = ''
      echo "Welcome to the devShell!"
    '';
  };
}
