{unstable-pkgs, ...}: {
  extensions = with unstable-pkgs.vscode-extensions; [
    dotjoshjohnson.xml
    rogalmic.vscode-xml-complete
  ];
}
