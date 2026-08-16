{lib, ...} @ args:
lib.mergeAttrsList (map (file: import file args) [
  ./ge-proton-packages.nix
])
