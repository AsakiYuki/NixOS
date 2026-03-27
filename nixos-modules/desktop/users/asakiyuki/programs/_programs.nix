{ ... }: let 
    asa-lib = import ../../../../../libs/_lib.nix;
in  {
    imports = [
        (asa-lib.root "/common/programs/nixvim/_nixvim.nix")
        
        ./cli/_cli.nix
        ./gui/_gui.nix
        
        ./_general.nix
    ];
}