{ pkgs, ... }: {
    home.file = {
        ".local/share/kio/servicemenus/open-with-code.desktop".source = ./sources/open-with-code.desktop;
    };
}