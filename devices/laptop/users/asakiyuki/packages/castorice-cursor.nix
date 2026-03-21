{ pkgs, ... }:
let 
    getFrom = url: hash: name: {
        gtk.enable = true;
        x11.enable = true;
        name = name;
        size = 24;
        package = pkgs.runCommand "moveUp" {} ''
                mkdir -p $out/share/icons
                ln -s ${pkgs.fetchzip {
                    url = url;
                    hash = hash;
                }} $out/share/icons/${name}
            '';
        };
    in getFrom 
        "https://www.asakiyuki.com/linux/theme/cursors/castorice.tar.gz"
        "sha256-nqAC+Itr+TXLGG8zYDBoBve+MeRckds5BM23DrsCTMM="
        "castorice-cursors"