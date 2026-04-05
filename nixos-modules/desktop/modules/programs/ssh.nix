{ pkgs, ... }:
{
  programs.ssh = {
    extraConfig = ''
      Host asakiyuki
          HostName server.asakiyuki.com
          User asakiyuki
          Port 15523

      Host junko
          HostName server.asakiyuki.com
          User junko
          Port 15523
    '';
  };
}

