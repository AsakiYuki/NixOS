{ pkgs, lib, ... }: let 
    SERVICE_MENUS = [
        "open-with-code"
    ];
in {
    home.file = builtins.listToAttrs (map (name: {
        name = ".local/share/kio/servicemenus/${name}.desktop";
        value.source = ./sources/${name}.desktop;
    }) SERVICE_MENUS);
}