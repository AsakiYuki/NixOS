{pkgs}: let
  inherit (pkgs) vscode-utils lib;
  extensions = lib.importJSON ../../../../assets/vscode.extensions.json;

  buildVscodeMarketplaceExtension = {
    ref,
    meta,
  }: let
    data = extensions."${ref.publisher}.${ref.name}";
  in (vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = ref // data;
    inherit meta;
  });
in {
  jbro.vscode-default-keybindings = buildVscodeMarketplaceExtension {
    ref = {
      name = "vscode-default-keybindings";
      publisher = "jbro";
    };
    meta = {
      description = "VSCode Default Keybindings is a keymap that enables you to load VSCode's default keybindings from another OS. Eg. use Mac keybindings on Windows.";
      downloadPage = "https://marketplace.visualstudio.com/items?itemName=jbro.vscode-default-keybindings";
      homepage = "https://github.com/jbro/vscode-default-keybindings";
      license = lib.licenses.unlicense;
    };
  };
  geodesdk.geode = buildVscodeMarketplaceExtension {
    ref = {
      name = "geode";
      publisher = "geodesdk";
    };

    meta = {
      description = "Utilities for the Geode Geometry Dash modding framework";
      downloadPage = "https://marketplace.visualstudio.com/items?itemName=geodesdk.geode";
      homepage = "https://github.com/geode-sdk/vscode";
      license = lib.licenses.mit;
    };
  };
  theqtcompany.qt-qml = buildVscodeMarketplaceExtension {
    ref = {
      name = "qt-qml";
      publisher = "theqtcompany";
    };

    meta = {
      description = "Qt QML Support";
      downloadPage = "https://marketplace.visualstudio.com/items?itemName=theqtcompany.qt-qml";
      homepage = "https://github.com/qt-labs/vscodeext";
      license = lib.licenses.lgpl3Only;
    };
  };
  bbenoist.qml = buildVscodeMarketplaceExtension {
    ref = {
      name = "qml";
      publisher = "bbenoist";
    };

    meta = {
      description = "QML language support for Visual Studio Code";
      downloadPage = "https://marketplace.visualstudio.com/items?itemName=bbenoist.qml";
      homepage = "https://github.com/bbenoist/vscode-qml";
      license = lib.licenses.mit;
    };
  };
}
