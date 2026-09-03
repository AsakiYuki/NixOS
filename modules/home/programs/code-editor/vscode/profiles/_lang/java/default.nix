{unstable, ...}: {
  extensions = with unstable.vscode-extensions; [
    redhat.java
    vscjava.vscode-java-test
    vscjava.vscode-spring-initializr
    vscjava.vscode-maven
    vscjava.vscode-java-debug
    vscjava.vscode-gradle
    vscjava.vscode-java-dependency
  ];
}
