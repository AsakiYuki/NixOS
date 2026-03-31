{ url, hash, name, size = 48, }: {
    cursors = { pkgs, ... }: {
        gtk.enable = true;
        x11.enable = true;
        name = name;
        size = size;
        package = pkgs.runCommand "moveUp" {} ''
                mkdir -p $out/share/icons
                ln -s ${pkgs.fetchzip {inherit url hash;}} $out/share/icons/${name}
            '';
        };
    }
}