{unstable, ...}: {
  extensions = with unstable.vscode-extensions; [
    # Utilities
    christian-kohler.path-intellisense
    aaron-bond.better-comments
    naumovs.color-highlight
    iliazeus.vscode-ansi
    hediet.vscode-drawio
    usernamehw.errorlens
    mikestead.dotenv
    alefragnani.project-manager
    natqe.reload
    tyriar.sort-lines
    rangav.vscode-thunder-client
    tomoki1207.pdf
    edwinkofler.vscode-assorted-languages
    ultram4rine.vscode-choosealicense
    openai.chatgpt
    zokugun.cron-tasks
    mrmlnc.vscode-duplicate
    ctcuff.font-preview
    moyu.snapcode
    cardinal90.multi-cursor-case-preserve
    uctakeoff.vscode-counter
    ms-vscode.hexeditor

    # Code status
    wakatime.vscode-wakatime
  ];
}
