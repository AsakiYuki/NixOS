{...} @ args: let
  plugins = import ./plugins.nix args;
  themes = import ./themes.nix args;
in {
  inherit (plugins) millennium-plugin millennium-plugins;
  inherit (themes) millennium-theme millennium-themes;
}
