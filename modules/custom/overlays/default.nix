{pkgs, ...}: {
  cage-xtmapper = pkgs.callPackage ./packages/cage-xtmapper.nix {};
  cider-2 = pkgs.callPackage ./packages/cider-2.nix {inherit pkgs;};
  bun-baseline = pkgs.callPackage ./packages/bun-baseline.nix {};
  geode-cli = pkgs.callPackage ./packages/geode-cli.nix {};
  lsfg-vk = pkgs.callPackage ./packages/lsfg-vk.nix {};
  geforce-now-electron = pkgs.callPackage ./packages/gfn-electron.nix {};
  vscode-extensions = pkgs.lib.recursiveUpdate pkgs.vscode-extensions (import ./vscode-extensions {pkgs = pkgs;});
}
