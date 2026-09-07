{...}: {
  imports = [
    ./cloudflare.nix
    ./forgejo.nix
    ./httpd.nix
    ./mysql.nix
    ./nextcloud.nix
    ./searx.nix
    ./sing-box.nix
  ];
}
