{...}: {
  imports = [
    ./cloudflare.nix
    ./forgejo.nix
    ./httpd.nix
    ./mysql.nix
    ./phpfpm.nix
  ];
}
