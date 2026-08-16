{
  final,
  prev,
}:
prev.lib.mergeAttrsList (map (file: import file {inherit final prev;}) [
  ./ge-proton-packages.nix
])
