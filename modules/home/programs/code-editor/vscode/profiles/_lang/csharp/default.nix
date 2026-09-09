{unstable-pkgs, ...}: {
  extensions = with unstable-pkgs.vscode-extensions; [
    ms-dotnettools.csharp
    ms-dotnettools.csdevkit
    ms-dotnettools.vscode-dotnet-runtime
  ];
}
