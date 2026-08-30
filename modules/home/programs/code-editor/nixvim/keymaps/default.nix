{...}: {
  globals.mapleader = " ";
  keymaps =
    []
    ++ (import ./_default.nix)
    ++ (import ./barbar.nix)
    ++ (import ./toggleterm.nix)
    ++ (import ./nvim-tree-toggle.nix);
}
