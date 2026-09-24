{pkgs, ...} @ args: {
  extensions = {...}: {
    _module.args = args;

    imports = [
      ./ext-btn.nix
      ./packages.nix
    ];
  };
}
