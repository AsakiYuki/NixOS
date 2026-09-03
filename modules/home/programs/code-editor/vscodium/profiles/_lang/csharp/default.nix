{unstable, ...}: {
  extensions = with unstable.vscode-extensions; [
    ms-dotnettools.csharp
    ms-dotnettools.csdevkit
    ms-dotnettools.vscode-dotnet-runtime
  ];
}
