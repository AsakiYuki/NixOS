{pkgs}: let
  inherit (pkgs) vscode-utils lib;
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in {
  jbro.vscode-default-keybindings = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-default-keybindings";
      publisher = "jbro";
      version = "0.2.61";
      hash = lib.fakeHash;
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
