{pkgs}: let
  inherit (pkgs) vscode-utils lib;
  inherit (vscode-utils) buildVscodeMarketplaceExtension;

  extensions = lib.importJSON ../../../assets/vscode.extensions.json;
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
  geodesdk.geode = buildVscodeMarketplaceExtension {
    mktplcRef =
      extensions."geodesdk.geode"
      // {
        name = "geode";
        publisher = "geodesdk";
      };

    meta = {
      description = "Utilities for the Geode Geometry Dash modding framework";
      downloadPage = "https://marketplace.visualstudio.com/items?itemName=geodesdk.geode";
      homepage = "https://github.com/geode-sdk/vscode";
      license = lib.licenses.mit;
      maintainers = [];
    };
  };
  theqtcompany.qt-qml = buildVscodeMarketplaceExtension {
    mktplcRef =
      extensions."theqtcompany.qt-qml"
      // {
        name = "qt-qml";
        publisher = "theqtcompany";
      };

    meta = {
      description = "Qt QML Support";
      downloadPage = "https://marketplace.visualstudio.com/items?itemName=theqtcompany.qt-qml";
      homepage = "https://github.com/qt-labs/vscodeext";
      license = lib.licenses.lgpl3Only;
      maintainers = [];
    };
  };
  bbenoist.qml = buildVscodeMarketplaceExtension {
    mktplcRef =
      extensions."bbenoist.qml"
      // {
        name = "qml";
        publisher = "bbenoist";
      };

    meta = {
      description = "QML language support for Visual Studio Code";
      downloadPage = "https://marketplace.visualstudio.com/items?itemName=bbenoist.qml";
      homepage = "https://github.com/bbenoist/vscode-qml";
      license = lib.licenses.mit;
      maintainers = [];
    };
  };
}
