{
  pkgs,
  lib,
  sources,
  ...
}: let
  platforms = {
    "x86_64-linux" = "linux-x64";
    "aarch64-linux" = "linux-arm64";
    "armv7l-linux" = "linux-armhf";
    "powerpc64le-linux" = "linux-ppc64le";
    "s390x-linux" = "linux-s390x";
    "x86_64-darwin" = "darwin-x64";
    "aarch64-darwin" = "darwin-arm64";
    "x86_64-windows" = "win32-x64";
    "aarch64-windows" = "win32-arm64";
    "i686-windows" = "win32-ia32";
  };
  targetPlatform = platforms.${pkgs.stdenv.hostPlatform.system} or null;
  extensions = sources.extensions.vscode;

  buildExtension = publisher: name: extension: let
    source = extension.src;
    selectedPlatform =
      if targetPlatform != null && builtins.hasAttr targetPlatform source.hash
      then targetPlatform
      else "universal";
    selectedHash = source.hash.${selectedPlatform} or null;
  in
    if selectedHash == null
    then throw "VS Code extension ${publisher}.${name} has no VSIX for ${pkgs.stdenv.hostPlatform.system} and no universal fallback"
    else
      pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef =
          {
            inherit publisher name;
            version = source.version;
            hash = selectedHash;
          }
          // lib.optionalAttrs (selectedPlatform != "universal") {
            arch = targetPlatform;
          };
        inherit (extension) meta;
      };
in (lib.recursiveUpdate
  (lib.mapAttrs (
      publisher: publisherExtensions:
        lib.mapAttrs (name: extension: buildExtension publisher name extension) publisherExtensions
    )
    extensions)
  {
    openai.chatgpt = let
      base = buildExtension "openai" "chatgpt" extensions.openai.chatgpt;
    in
      pkgs.runCommand "vscode-extension-openai-chatgpt-${extensions.openai.chatgpt.src.version}" {
        meta = base.meta;
      } ''
        mkdir -p "$out/share/vscode/extensions"
        cp -a "${base}/share/vscode/extensions/openai.chatgpt" "$out/share/vscode/extensions/"

        bundle="$out/share/vscode/extensions/openai.chatgpt/webview/assets/app-initial-41ab338a184f.js"
        old_gate='if(!t)return e||n==null?`none`:n===`chatgptAuthTokens`||n===`chatgpt`?`2025-09-15-full-chatgpt-auth`:`2025-09-15-apikey-auth`}'
        new_gate='if(!t)return`none`}'
        substituteInPlace "$bundle" --replace-fail "$old_gate" "$new_gate"
      '';

    catppuccin.catppuccin-vsc = pkgs.vscode-extensions.catppuccin.catppuccin-vsc.overrideAttrs (prev: {
      postFixup = ''
        substituteInPlace $out/share/vscode/extensions/catppuccin.catppuccin-vsc/dist/main.cjs \
        --replace-warn 'var Xt=async t=>{' 'var Xt=async t=>{return null;'
      '';
    });
  })
