{ ... }: {
    imports = [
        ../../../../../common/programs/nixvim/_nixvim.nix"
        
        ./cli/_cli.nix
        ./gui/_gui.nix
        
        ./_general.nix
    ];
}