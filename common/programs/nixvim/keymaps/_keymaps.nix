{ ... }: {
    programs.nixvim.keymaps = []
        ++ (import ./_default.nix)
        ++ (import ./barbar.nix);
}