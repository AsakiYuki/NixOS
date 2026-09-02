{unstable, ...}: {
  imports = [
    ./profiles
  ];

  programs.vscodium = {
    package = unstable.vscodium;
    argvSettings = {};
  };
}
