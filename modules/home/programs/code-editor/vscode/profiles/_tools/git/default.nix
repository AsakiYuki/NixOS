{unstable, ...}: {
  userSettings = {
    "git.enableSmartCommit" = true;
    "git.autofetch" = true;
  };

  extensions = with unstable.vscode-extensions; [
    mhutchie.git-graph
    github.vscode-github-actions
    github.codespaces
  ];
}
