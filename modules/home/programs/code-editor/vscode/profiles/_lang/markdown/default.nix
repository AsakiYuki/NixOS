{unstable-pkgs, ...}: {
  extensions = with unstable-pkgs.vscode-extensions; [
    yzhang.markdown-all-in-one
    davidanson.vscode-markdownlint
    unifiedjs.vscode-mdx
  ];
}
