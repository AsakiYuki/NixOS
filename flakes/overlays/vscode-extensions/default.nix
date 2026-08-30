{pkgs}: let
  inherit (pkgs) vscode-utils lib;
  inherit (vscode-utils) buildVscodeMarketplaceExtension;

  extensions = (lib.importJSON ../../../assets/packages.json).vscode-extensions;
in {
  jbro.vscode-default-keybindings = buildVscodeMarketplaceExtension {
    mktplcRef =
      extensions."jbro.vscode-default-keybindings"
      // {
        name = "vscode-default-keybindings";
        publisher = "jbro";
      };
    meta = {
      description = "VSCode Default Keybindings is a keymap that enables you to load VSCode's default keybindings from another OS. Eg. use Mac keybindings on Windows.";
      downloadPage = "https://marketplace.visualstudio.com/items?itemName=jbro.vscode-default-keybindings";
      homepage = "https://github.com/jbro/vscode-default-keybindings";
      license = lib.licenses.unlicense;
      maintainers = [];
    };
  };
}
