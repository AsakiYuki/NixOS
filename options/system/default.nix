{ lib, ... }:
{
    options.asa.system = {
        name = lib.mkOption {
            type = lib.types.str;
            default = "desktop";
            description = "Flake name for quick rebuild";
        };
    };
}