{unstable, ...}: {
  userSettings = {
    "prettier.printWidth" = 120;
    "prettier.arrowParens" = "avoid";
    "prettier.tabWidth" = 2;
    "prettier.useTabs" = true;
    "prettier.semi" = false;

    "editor.defaultFormatter" = "esbenp.prettier-vscode";
    "notebook.defaultFormatter" = "esbenp.prettier-vscode";
  };

  extensions = with unstable.vscode-extensions; [
    esbenp.prettier-vscode
    inferrinizzard.prettier-sql-vscode
    code-nature.nilesoft-shell-file-formatter
    jinxdash.prettier-rust
    rvest.vs-code-prettier-eslint
    inferrinizzard.prettier-sql-vscode
  ];
}
