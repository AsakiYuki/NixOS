{ name ? "aemeath", size ? 48, inputs }:
let 
    _b = name: url: hash: { inherit name url hash; };
    _q = name: hash: _b name "https://static.asakiyuki.com/cursors/linux/${name}.tar.gz" hash;

    cursors = {
        castorice = _q "castorice" "sha256-nqAC+Itr+TXLGG8zYDBoBve+MeRckds5BM23DrsCTMM=";
        aemeath = _q "aemeath" "sha256-0eEsUks5MwW4g5Xau24SgchX+LD9Ra3azAH0KL9JzQw=";
        elysia = _q "elysia" "sha256-mjDHklWrX5Pp/vejRQiMk0VA6afY04HXGyGD0PcopdI=";
        cartethyia = _q "cartethyia" "sha256-jYIDoX+rfUjw6LXrqE4y8j5IL0vByrrRkgRuz08Zy6U=";
    };

    cursor = cursors.${name};
in
{
    cursors = { pkgs , ... }:
    {
        gtk.enable = true;
        x11.enable = true;
        name = name;
        size = size;
        package = pkgs.runCommand "moveUp" { } ''
            mkdir -p $out/share/icons
            ln -s ${
                pkgs.fetchzip {
                    url = cursor.url;
                    hash = cursor.hash;
                }
            } $out/share/icons/${name}
        '';
    };
}