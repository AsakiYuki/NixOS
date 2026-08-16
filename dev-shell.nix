{nixpkgs, ...} @ inputs: let
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    overlays = import ./overlays/inputs-overlays.nix inputs;
  };
in {
  devShells.x86_64-linux.default = pkgs.mkShell {
    buildInputs = with pkgs; [
      hello
    ];

    shellHook = ''
      echo "Welcome to the devShell!"
    '';
  };
}
