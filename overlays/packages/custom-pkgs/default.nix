{lib, ...} @ args: let
  custom-pkgs-data = lib.importJSON ../../../assets/packages.json;
  custom-pkgs = {
    cage-xtmapper = ./cage-xtmapper.nix;
    cider-2 = ./cider-2.nix;
    bun-baseline = ./bun-baseline.nix;
    geode-cli = ./geode-cli.nix;
    lsfg-vk = ./lsfg-vk.nix;
    geforce-now-electron = ./gfn-electron.nix;
    opennow = ./opennow.nix;
    zen-browser-unwarpped = ./zen-browser-unwarpped.nix;
    zen-browser = ./zen-browser.nix;
    bedrock-on-linux = ./bedrock-on-linux.nix;
    iris = ./iris.nix;
  };
in (lib.mapAttrs' (name: path: {
    inherit name;
    value = import path (args // {data = custom-pkgs-data;});
  })
  custom-pkgs)
