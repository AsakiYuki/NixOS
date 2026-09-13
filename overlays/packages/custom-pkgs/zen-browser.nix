{pkgs, ...} @ args: (pkgs.wrapFirefox (import ./zen-browser-unwrapped.nix args) {
  pname = "zen-browser";
})
