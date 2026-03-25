{ pkgs, lib, ... }: {
    home.file = builtins.listToAttrs (map (name: {
        name = ".local/share/kio/servicemenus/${name}.desktop";
        value.source = ../../../../../../assets/service-menus/${name}.desktop;
    }) (import ../../../../../../assets/service-menus/_services-menu.nix)) // {
        ".config/obs-studio/themes".source = pkgs.callPackage ../../../../../../packages/catppuccin-obs.nix {};
        ".mozilla/firefox/default/search.json.mozlz4".force = lib.mkForce true;
    };
}