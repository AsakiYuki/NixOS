{ pkgs, lib, ... }: let 
    SERVICE_MENUS = [
        "openwithcode"
    ];
in {
    home.file = builtins.listToAttrs (map (name: {
        name = ".local/share/kio/servicemenus/${name}.desktop";
        value.source = ./sources/servicemenus/${name}.desktop;
    }) SERVICE_MENUS);
}