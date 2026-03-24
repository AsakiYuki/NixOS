{ pkgs, ... }:
let 
    getFrom = url: hash: name: {
        gtk.enable = true;
        x11.enable = true;
        name = name;
        size = 48;
        package = pkgs.runCommand "moveUp" {} ''
                mkdir -p $out/share/icons
                ln -s ${pkgs.fetchzip {
                    url = url;
                    hash = hash;
                }} $out/share/icons/${name}
            '';
        };
    in getFrom 
        "https://static.asakiyuki.com/nixos/elysia-cursors.tar.gz"
        "sha256-mjDHklWrX5Pp/vejRQiMk0VA6afY04HXGyGD0PcopdI="
        "elysia-cursors"