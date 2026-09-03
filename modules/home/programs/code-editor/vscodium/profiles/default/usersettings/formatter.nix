{lib, ...}: let
  formatter-per-lang = {
    cpp = "ms-vscode.cpptools";
    xml = "rogalmic.vscode-xml-complete";
    nix = "jnoortheen.nix-ide";
    qml = "theqtcompany.qt-qml";
    php = "bmewburn.vscode-intelephense-client";
    shellscript = "mads-hartmann.bash-ide-vscode";
    # json = "vscode.json-language-features";
    # jsonc = "vscode.json-language-features";
  };
in {
  userSettings =
    lib.mapAttrs' (name: value: {
      name = "[${name}]";
      value."editor.defaultFormatter" = value;
    })
    formatter-per-lang;
}
