{pkgs, ...}: {
  programs.vscodium.profiles.default.userSettings = {
    "cmake.cmakePath" = "${pkgs.cmake}/bin/cmake";
  };
}
