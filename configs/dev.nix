{inputs, ...}: (import ../helpers/devShells.nix inputs {
  default = {
    overlays = import ../overlays/inputs-overlays.nix inputs;
    shell = {pkgs, ...}: {
      buildInputs = with pkgs; [
        bun
        vsce
      ];

      shellHook = ''
        echo "Welcome to NixOS DevShell!"

        if [ -e .env ]; then
          source .env
        fi

        export NIX_CONFIG="access-tokens = github.com=''${GH_TOKEN}"

        alias repl="nix repl ."
        alias agenix="./agenix.sh"
      '';
    };
  };
})
