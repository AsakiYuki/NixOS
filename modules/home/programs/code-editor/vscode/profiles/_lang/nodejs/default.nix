{unstable, ...}: {
  userSettings = {
    "wallaby.noAutomaticInstall" = false;
  };

  extensions = with unstable.vscode-extensions; [
    christian-kohler.npm-intellisense
    wallabyjs.wallaby-vscode
    wallabyjs.quokka-vscode
    tobermory.es6-string-html
    yoavbls.pretty-ts-errors
    dbaeumer.vscode-eslint
    wix.vscode-import-cost
    meganrogge.template-string-converter
    adrianwilczynski.alpine-js-intellisense
    astro-build.astro-vscode
    pushqrdx.inline-html
    lllllllqw.jsdoc
  ];
}
