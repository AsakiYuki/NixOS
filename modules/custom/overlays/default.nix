{pkgs, ...} @ args: let
  data = pkgs.lib.importJSON ../../../assets/packages.json;

  imports = {
    cage-xtmapper = ./packages/cage-xtmapper.nix;
    cider-2 = ./packages/cider-2.nix;
    bun-baseline = ./packages/bun-baseline.nix;
    geode-cli = ./packages/geode-cli.nix;
    lsfg-vk = ./packages/lsfg-vk.nix;
    geforce-now-electron = ./packages/gfn-electron.nix;
  };
in
  (pkgs.lib.mapAttrs' (name: value: {
      inherit name;
      value = import value (args
        // {
          inherit data;
          lib = pkgs.lib;
        });
    })
    imports)
  // {
    vscode-extensions = pkgs.lib.recursiveUpdate pkgs.vscode-extensions (import ./vscode-extensions {pkgs = pkgs;});
  }
