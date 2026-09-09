{unstable-pkgs, ...}: {
  userSettings = {
    "vscode-default-keybindings.removeOSKeybindings" = true;
    "vscode-default-keybindings.windowsKeybindings" = true;
  };

  extensions = with unstable-pkgs.vscode-extensions; [
    jbro.vscode-default-keybindings
  ];
}
