{unstable, ...}: {
  programs.vscodium.profiles.default.extensions = with unstable.vscode-extensions; [
    # Themes
    catppuccin.catppuccin-vsc
    pkief.material-icon-theme

    # Utilities
    firefox-devtools.vscode-firefox-debug
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
    jbro.vscode-default-keybindings
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
    ms-vscode.live-server
    ms-vscode.remote-explorer
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-ssh-edit

    # Docker
    docker.docker
    ms-azuretools.vscode-docker
    ms-azuretools.vscode-containers

    # Git/Github
    eamodio.gitlens
    mhutchie.git-graph
    github.vscode-github-actions
    github.codespaces

    # Nix
    arrterian.nix-env-selector
    bbenoist.nix
    jnoortheen.nix-ide

    # Dotnet
    ms-dotnettools.vscode-dotnet-runtime

    # C/C++
    geodesdk.geode
    ms-vscode.makefile-tools
    ms-vscode.cpptools
    ms-vscode.cmake-tools
    ms-vscode.cpp-devtools

    # C#
    ms-dotnettools.csharp
    ms-dotnettools.csdevkit

    # Rust
    rust-lang.rust-analyzer

    # Java
    redhat.java
    vscjava.vscode-java-test
    vscjava.vscode-spring-initializr
    vscjava.vscode-maven
    vscjava.vscode-java-debug
    vscjava.vscode-gradle
    vscjava.vscode-java-dependency

    # Python
    ms-python.vscode-pylance
    ms-python.python
    ms-python.debugpy

    # LaTeX
    james-yu.latex-workshop

    # QT/QML
    theqtcompany.qt-qml
    bbenoist.qml

    # JavaScript/TypeScript
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

    # JSON
    joshuapoehls.json-escaper

    # HTML/CSS/SASS
    ecmel.vscode-html-css
    formulahendry.auto-close-tag
    formulahendry.auto-rename-tag
    ecmel.vscode-html-css
    gencer.html-slim-scss-css-class-completion
    svelte.svelte-vscode
    formulahendry.auto-rename-tag
    thekalinga.bootstrap4-vscode
    syler.sass-indented
    mrmlnc.vscode-scss
    bradlc.vscode-tailwindcss

    # Minecraft
    mojang-studios.minecraft-debugger
    zz5840.minecraft-lang-colorizer
    stevertus.mcscript
    jannisx11.snowstorm
    minecraftcommands.syntax-mcfunction
    blockceptionltd.blockceptionvscodeminecraftbedrockdevelopmentextension

    # Assembly
    p13xforever.language-x86-64-assembly

    # V
    vosca.vscode-v-analyzer

    # Go
    golang.go

    # Lua
    sumneko.lua

    # PHP
    bmewburn.vscode-intelephense-client

    # TOML
    tamasfe.even-better-toml

    # Markdown
    yzhang.markdown-all-in-one
    davidanson.vscode-markdownlint
    unifiedjs.vscode-mdx

    # Shell
    foxundermoon.shell-format
    mads-hartmann.bash-ide-vscode

    # Nushell
    thenuprojectcontributors.vscode-nushell-lang

    # Formatter
    esbenp.prettier-vscode
    inferrinizzard.prettier-sql-vscode
    code-nature.nilesoft-shell-file-formatter
    jinxdash.prettier-rust
    rvest.vs-code-prettier-eslint
    inferrinizzard.prettier-sql-vscode

    # SQL
    cweijan.vscode-mysql-client2

    # XML
    dotjoshjohnson.xml
    rogalmic.vscode-xml-complete

    # Code status
    leonardssh.vscord
    wakatime.vscode-wakatime
  ];
}
