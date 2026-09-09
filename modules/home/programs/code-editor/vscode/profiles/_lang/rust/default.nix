{unstable-pkgs, ...}: {
  extensions = with unstable-pkgs.vscode-extensions; [
    rust-lang.rust-analyzer
  ];
}
