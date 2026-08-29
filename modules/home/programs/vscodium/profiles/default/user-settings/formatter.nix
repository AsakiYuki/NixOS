{lib, ...}: let
  formatter-per-lang = {
    cpp = "ms-vscode.cpptools";
    xml = "rogalmic.vscode-xml-complete";
    nix = "jnoortheen.nix-ide";
    qml = "theqtcompany.qt-qml";
    php = "bmewburn.vscode-intelephense-client";
    shellscript = "mads-hartmann.bash-ide-vscode";
  };
in {
  programs.vscodium.profiles.default.userSettings =
    lib.mergeAttrs {
      # Formatter
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "notebook.defaultFormatter" = "esbenp.prettier-vscode";
    } (lib.mapAttrs' (name: value: {
        name = "[${name}]";
        value."editor.defaultFormatter" = value;
      })
      formatter-per-lang);
}
