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
    yoavbls.pretty-ts-errors
    dbaeumer.vscode-eslint
    wix.vscode-import-cost
    meganrogge.template-string-converter

    # HTML/CSS/SASS
    formulahendry.auto-close-tag
    formulahendry.auto-rename-tag
    ecmel.vscode-html-css
    gencer.html-slim-scss-css-class-completion
    svelte.svelte-vscode
    bradlc.vscode-tailwindcss

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

    # XML
    dotjoshjohnson.xml

    # Code status
    leonardssh.vscord
    wakatime.vscode-wakatime
  ];
}
