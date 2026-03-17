{ pkgs, ... }: {
    programs = 
        import ./nix-ld.nix { inherit pkgs; }; //
        import ./wayvnc.nix { inherit pkgs; }; // {
        zsh.enable = true;
    };
}