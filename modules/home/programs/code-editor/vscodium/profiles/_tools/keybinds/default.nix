{unstable, ...}: {
  userSettings = {
    "vscode-default-keybindings.removeOSKeybindings" = true;
    "vscode-default-keybindings.windowsKeybindings" = true;
  };

  extensions = with unstable.vscode-extensions; [
    jbro.vscode-default-keybindings
  ];
}
