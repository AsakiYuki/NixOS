{ pkgs, ... }: {
    programs = 
        import ./nix-ld.nix { inherit pkgs; } // {
        zsh.enable = true;
    };
}