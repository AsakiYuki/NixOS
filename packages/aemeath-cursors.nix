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
        "https://static.asakiyuki.com/nixos/aemeath-cusros.tar.gz"
        "sha256-0eEsUks5MwW4g5Xau24SgchX+LD9Ra3azAH0KL9JzQw="
        "aemeath-cursors";