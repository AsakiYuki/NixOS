{
  pkgs,
  lib,
  ...
}:
lib.mergeAttrsList [
  {
    catppuccin.catppuccin-vsc = pkgs.vscode-extensions.catppuccin.catppuccin-vsc.overrideAttrs (prev: {
      postFixup = ''
        substituteInPlace $out/share/vscode/extensions/catppuccin.catppuccin-vsc/dist/main.cjs \
          --replace-warn 'var Xt=async t=>{' 'var Xt=async t=>{return null;'
      '';
    });
  }
  (lib.mapAttrs (publisher: extensions:
    lib.mapAttrs (name: {
      src,
      meta,
    }: (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = {inherit publisher name;} // src;
      inherit meta;
    }))
    extensions)
  (lib.importJSON ../../assets/vscode.extensions.json))
]
