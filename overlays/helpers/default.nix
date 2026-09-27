{pkgs, ...}: {
  buildFirefoxXpiAddon = import ./buildFirefoxXpiAddon {inherit pkgs;};
}
