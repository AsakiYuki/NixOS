{ pkgs, lib, asa-lib, config, home, ... }: {
    home.file = builtins.listToAttrs (map (name: {
        name = ".local/share/kio/servicemenus/${name}.desktop";
        value.source = (asa-lib.root "/assets/service-menus/${name}.desktop");
    }) (import (asa-lib.root "/assets/service-menus/_services-menu.nix"))) // {
        ".config/obs-studio/themes".source = pkgs.callPackage (asa-lib.root "/packages/catppuccin-obs.nix") {};
        ".mozilla/firefox/default/search.json.mozlz4".force = lib.mkForce true;

        "SteamApps".source = config.lib.file.mkOutOfStoreSymlink "${home}/.local/share/Steam/steamapps";
        "Development/KDE-Widget".source = config.lib.file.mkOutOfStoreSymlink "${home}/.local/share/plasma/plasmoids";
        "Development/SplashScreen".source = config.lib.file.mkOutOfStoreSymlink "${home}/.local/share/plasma/look-and-feel";
        "Development/DesktopEffects".source = config.lib.file.mkOutOfStoreSymlink "${home}/.local/share/kwin/effects";
    };
}
