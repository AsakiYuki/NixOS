{pkgs, ...}: {
  userSettings = {
    "cmake.cmakePath" = "${pkgs.cmake}/bin/cmake";
  };
}
