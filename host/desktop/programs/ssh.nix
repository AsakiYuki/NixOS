{...}: {
  programs.ssh.extraConfig = ''
    Host server
      HostName asakiyuki.com
      User asakiyuki
      Port 15523

    Host honor
      HostName 192.168.2.101
      User u0_a289
      Port 8022
  '';
}
