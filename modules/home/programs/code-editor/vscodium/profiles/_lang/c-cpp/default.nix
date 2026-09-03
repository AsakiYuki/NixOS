{
  unstable,
  pkgs,
  ...
}: {
  userSettings = {
    "cmake.cmakePath" = "${pkgs.cmake}/bin/cmake";
  };

  extensions = with unstable.vscode-extensions; [
    ms-vscode.makefile-tools
    ms-vscode.cpptools
    ms-vscode.cmake-tools
    ms-vscode.cpp-devtools
  ];
}
