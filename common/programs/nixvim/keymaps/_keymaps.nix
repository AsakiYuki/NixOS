{ ... }: {
    programs.nixvim = {
        globals.mapleader = " ";
        keymaps = []
            ++ (import ./_default.nix)
            ++ (import ./barbar.nix);
    };
}