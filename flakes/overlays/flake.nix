{
  description = "The Asa's NixOS custom packages overlay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = {...}: {
    overlays.default = final: prev: {
      cage-xtmapper = final.callPackage ./packages/cage-xtmapper.nix {};
      cider-2 = final.callPackage ./packages/cider-2.nix {inherit prev;};
      bun-baseline = final.callPackage ./packages/bun-baseline.nix {};
      geode-cli = final.callPackage ./packages/geode-cli.nix {};
      lsfg-vk = final.callPackage ./packages/lsfg-vk.nix {};
      geforce-now-electron = final.callPackage ./packages/gfn-electron.nix {};
      vscode-extensions = prev.vscode-extensions // (import ./vscode-extensions {pkgs = prev;});
    };
  };
}
