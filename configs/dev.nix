{inputs, source-data, ...}: (import ../helpers/devShells.nix inputs {
  default = {
    overlays = import ../overlays/inputs-overlays.nix (inputs // { sources = source-data; });
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

        alias add-firefox-addons="bun run add-firefox-addons"
        alias add-chrome-extensions="bun run add-chrome-extensions"
        alias add-vscode-extensions="bun run add-vscode-extensions"
      '';
    };
  };
})
