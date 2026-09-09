{unstable-pkgs, ...}: {
  extensions = with unstable-pkgs.vscode-extensions; [
    docker.docker
    ms-azuretools.vscode-docker
    ms-azuretools.vscode-containers
  ];
}
