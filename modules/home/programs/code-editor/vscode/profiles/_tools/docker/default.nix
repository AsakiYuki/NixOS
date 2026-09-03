{unstable, ...}: {
  extensions = with unstable.vscode-extensions; [
    docker.docker
    ms-azuretools.vscode-docker
    ms-azuretools.vscode-containers
  ];
}
