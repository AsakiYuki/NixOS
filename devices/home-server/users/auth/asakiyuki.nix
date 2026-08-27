{lib, ...}: {
  users.users.asakiyuki.openssh.authorizedKeys.keys = lib.mkAuthorizedKeys [
    "/home-server/asakiyuki.nixos.pub"

    "/ideapad-slim-5-14apk10/asakiyuki.nixos.pub"
    "/ideapad-slim-5-14apk10/asakiyuki.nixos.wsl.pub"
    "/ideapad-slim-5-14apk10/asakiyuki.windows.pub"

    "/macos/asakiyuki.macos.pub"
    "/android/asakiyuki.honor.pub"
  ] "/assets/public/ssh";

  home-manager.users.asakiyuki.programs.bash.initExtra = ''
    function fix-ssl() {
      sudo systemctl restart "acme-$1.service"
      sudo systemctl reload nginx
    }
  '';
}
