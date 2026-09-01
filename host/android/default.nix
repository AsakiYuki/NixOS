{pkgs, ...}: {
  environment.packages = with pkgs; [
    vim
    git
  ];

  environment.etcBackupExtension = ".bak";

  system.stateVersion = "25.11";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
