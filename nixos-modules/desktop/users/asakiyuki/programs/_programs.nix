{ ... }: {
    imports = [        
        ./cli/_cli.nix
        ./gui/_gui.nix
        
        ./_general.nix
    ];
}