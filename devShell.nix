{nixpkgs, ...} @ inputs: let
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    overlays = import ./overlays/inputs-overlays.nix inputs;
  };
in {
  devShells.x86_64-linux.default = pkgs.mkShell {
    buildInputs = with pkgs; [
      bun
    ];

    shellHook = ''
      echo "Welcome to NixOS DevShell!"

      source .env
      export NIX_CONFIG="access-tokens = github.com=''${GH_TOKEN}"

      alias repl="nix repl ."
      alias agenix="./agenix.sh"
    '';
  };
}
