{ lib, config, ... }: {
    imports = [
        ./services.nix
    ];
    
    options.device = {
        admin-email = lib.mkOption {
            type = lib.types.str;
            default = "vantrong2007vn@gmail.com";
            description = "admin email for git";
        };
    };
}