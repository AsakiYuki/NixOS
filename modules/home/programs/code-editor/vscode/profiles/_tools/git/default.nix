{unstable-pkgs, ...}: {
  userSettings = {
    "git.enableSmartCommit" = true;
    "git.autofetch" = true;
  };

  extensions = with unstable-pkgs.vscode-extensions; [
    mhutchie.git-graph
    github.vscode-github-actions
    github.codespaces
  ];
}
