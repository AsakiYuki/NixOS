{
  config,
  lib,
  osConfig ? { },
  pkgs,
  ...
}:
let
  extensions = lib.importJSON (lib.root "/assets/chromium.extensions.json");
  systemConfig = if osConfig == null then { } else osConfig;
  managedExtensions = lib.attrByPath [
    "programs"
    "chromium"
    "extraOpts"
    "3rdparty"
    "extensions"
  ] { } systemConfig;
  configurableExtensions = lib.filterAttrs (
    _: extension: builtins.hasAttr extension.id managedExtensions
  ) extensions;
  chromiumExtensions = lib.mapAttrsToList (name: extension: {
    inherit (extension) id version;
    crxPath = "${pkgs.chromium-extensions.${name}}/share/chromium/extensions/${extension.id}.crx";
  }) configurableExtensions;
in
{
  programs.chromium = {
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-features=UseOzonePlatform,UseHDRTransferFunction,WaylandWindowDecorations,Vulkan"
    ];
    extensions = lib.optionals config.programs.chromium.enable chromiumExtensions;
  };
}
