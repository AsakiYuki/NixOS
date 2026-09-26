{...}: {
  imports = [
    ./cloudflare.nix
    ./forgejo.nix
    ./httpd.nix
    ./mysql.nix
    ./searx.nix
    ./sing-box.nix
  ];
}
