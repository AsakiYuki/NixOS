{unstable, ...}: {
  extensions = with unstable.vscode-extensions; [
    rust-lang.rust-analyzer
  ];
}
