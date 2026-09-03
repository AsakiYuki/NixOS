{unstable, ...}: {
  extensions = with unstable.vscode-extensions; [
    yzhang.markdown-all-in-one
    davidanson.vscode-markdownlint
    unifiedjs.vscode-mdx
  ];
}
