{unstable, ...}: {
  extensions = with unstable.vscode-extensions; [
    ms-vscode.remote-explorer
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-ssh-edit
  ];
}
