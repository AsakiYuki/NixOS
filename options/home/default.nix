{ lib, ... }:
{
    options.asa.home = {
        cursors = lib.mkOption {
            type = lib.types.str;
            default = "aemeath";
            description = "Set cursors theme";
        };
    };
}