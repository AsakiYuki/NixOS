{nixpkgs, ...}: let
  pkgs = import nixpkgs {system = "x86_64-linux";};
in {
  devShells.x86_64-linux.default = pkgs.mkShell {
    buildInput = with pkgs; [hello];

    shellHook = ''
      echo "Welcome to the devShell!"
    '';
  };
}
