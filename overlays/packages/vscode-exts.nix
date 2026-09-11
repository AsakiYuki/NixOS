{
  pkgs,
  lib,
  ...
}: let
  extensions = lib.importJSON ../../assets/vscode.extensions.json;
in
  lib.mergeAttrsList [
    {
      catppuccin.catppuccin-vsc = pkgs.vscode-extensions.catppuccin.catppuccin-vsc.overrideAttrs (prev: {
        postFixup = ''
          substituteInPlace $out/share/vscode/extensions/catppuccin.catppuccin-vsc/dist/main.cjs \
            --replace-warn 'var Xt=async t=>{' 'var Xt=async t=>{return null;'
        '';
      });
    }

    (lib.mapAttrs' (extension_publisher: extensions_list: {
        name = extension_publisher;
        value =
          lib.mapAttrs' (extension_name: extension_infos: {
            name = extension_name;
            value = let
              extension_id = "${extension_publisher}.${extension_name}";
              data = extensions.${extension_id};
            in (pkgs.vscode-utils.buildVscodeMarketplaceExtension ({
                mktplcRef =
                  data
                  // {
                    publisher = extension_publisher;
                    name = extension_name;
                  };
                downloadPage = "https://marketplace.visualstudio.com/items?itemName=${extension_id}";
              }
              // extension_infos));
          })
          extensions_list;
      }) {
        jbro.vscode-default-keybindings = {
          description = "VSCode Default Keybindings is a keymap that enables you to load VSCode's default keybindings from another OS. Eg. use Mac keybindings on Windows.";
          homepage = "https://github.com/jbro/vscode-default-keybindings";
          license = lib.licenses.unlicense;
        };

        geodesdk.geode = {
          description = "Utilities for the Geode Geometry Dash modding framework";
          homepage = "https://github.com/geode-sdk/vscode";
          license = lib.licenses.mit;
        };

        theqtcompany.qt-qml = {
          description = "Qt QML Support";
          homepage = "https://github.com/qt-labs/vscodeext";
          license = lib.licenses.lgpl3Only;
        };

        bbenoist.qml = {
          description = "QML language support for Visual Studio Code";
          homepage = "https://github.com/bbenoist/vscode-qml";
          license = lib.licenses.mit;
        };

        adrianwilczynski.alpine-js-intellisense = {
          description = "Simple IntelliSense & Snippets for Alpine.js framework.";
          homepage = "https://github.com/AdrianWilczynski/AlpineIntelliSense";
          license = lib.licenses.mit;
        };

        edwinkofler.vscode-assorted-languages = {
          description = "Assorted languages support for Visual Studio Code";
          homepage = "https://github.com/edwinkofler/vscode-assorted-languages";
          license = lib.licenses.mit;
        };

        astro-build.astro-vscode = {
          description = "Language support for Astro";
          homepage = "https://github.com/withastro/astro";
          license = lib.licenses.mit;
        };

        formulahendry.auto-rename-tag = {
          description = "Auto rename paired HTML/XML tag";
          homepage = "https://github.com/formulahendry/vscode-auto-rename-tag";
          license = lib.licenses.mit;
        };

        thekalinga.bootstrap4-vscode = {
          description = "Bootstrap 4 snippets based on documentation + Font awesome 4 + Font Awesome 5 Free & Pro snippets";
          homepage = "https://github.com/1tontech/bootstrap4-snippets";
          license = lib.licenses.mit;
        };

        ms-vscode.cpp-devtools = {
          description = "C++ DevTools for Visual Studio Code";
          homepage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpp-devtools";
          license = lib.licenses.unfree;
        };

        ultram4rine.vscode-choosealicense = {
          description = "Choose a license for your project in VS Code";
          homepage = "https://github.com/ultram4rine/vscode-choosealicense";
          license = lib.licenses.mit;
        };

        openai.chatgpt = {
          description = "ChatGPT - The official OpenAI extension for VS Code";
          homepage = "https://marketplace.visualstudio.com/items?itemName=openai.chatgpt";
          license = lib.licenses.unfree;
        };

        zokugun.cron-tasks = {
          description = "Run tasks on a schedule";
          homepage = "https://github.com/zokugun/vscode-cron-tasks";
          license = lib.licenses.mit;
        };

        mrmlnc.vscode-duplicate = {
          description = "Ability to duplicate files in VS Code";
          homepage = "https://github.com/mrmlnc/vscode-duplicate";
          license = lib.licenses.mit;
        };

        tobermory.es6-string-html = {
          description = "ES6 Template Literals editor with Syntax Highlighting";
          homepage = "https://github.com/tobermory/es6-string-html";
          license = lib.licenses.mit;
        };

        ctcuff.font-preview = {
          description = "Preview fonts in VS Code";
          homepage = "https://github.com/ctcuff/vscode-font-preview";
          license = lib.licenses.mit;
        };

        ecmel.vscode-html-css = {
          description = "HTML id and class attribute completion for Visual Studio Code";
          homepage = "https://github.com/ecmel/vscode-html-css";
          license = lib.licenses.mit;
        };

        pushqrdx.inline-html = {
          description = "Inline HTML syntax highlighting in JS/TS template literals";
          homepage = "https://github.com/pushqrdx/vscode-inline-html";
          license = lib.licenses.mit;
        };

        lllllllqw.jsdoc = {
          description = "JSDoc support for VS Code";
          homepage = "https://marketplace.visualstudio.com/items?itemName=lllllllqw.jsdoc";
          license = lib.licenses.mit;
        };

        joshuapoehls.json-escaper = {
          description = "Escape and unescape troublesome characters in JSON string values";
          homepage = "https://github.com/joshuapoehls/vscode-json-escaper";
          license = lib.licenses.mit;
        };

        mojang-studios.minecraft-debugger = {
          description = "Minecraft Debugger for Visual Studio Code";
          homepage = "https://marketplace.visualstudio.com/items?itemName=mojang-studios.minecraft-debugger";
          license = lib.licenses.unfree;
        };

        zz5840.minecraft-lang-colorizer = {
          description = "Colorizer for Minecraft .lang files";
          homepage = "https://marketplace.visualstudio.com/items?itemName=zz5840.minecraft-lang-colorizer";
          license = lib.licenses.mit;
        };

        stevertus.mcscript = {
          description = "MCScript language support for VS Code";
          homepage = "https://github.com/Stevertus/mcscript";
          license = lib.licenses.mit;
        };

        cardinal90.multi-cursor-case-preserve = {
          description = "Preserves case when editing with multiple cursors";
          homepage = "https://github.com/Cardinal90/multi-cursor-case-preserve";
          license = lib.licenses.mit;
        };

        cweijan.vscode-mysql-client2 = {
          description = "Database Client for VS Code - supports MySQL, PostgreSQL, SQLite, Redis, MongoDB and more";
          homepage = "https://github.com/cweijan/vscode-database-client";
          license = lib.licenses.unfree;
        };

        code-nature.nilesoft-shell-file-formatter = {
          description = "Nilesoft Shell file formatter for VS Code";
          homepage = "https://marketplace.visualstudio.com/items?itemName=code-nature.nilesoft-shell-file-formatter";
          license = lib.licenses.mit;
        };

        jinxdash.prettier-rust = {
          description = "Prettier Rust formatter plugin";
          homepage = "https://github.com/jinxdash/prettier-plugin-rust";
          license = lib.licenses.mit;
        };

        rvest.vs-code-prettier-eslint = {
          description = "A Visual Studio Code Extension to format JavaScript and TypeScript code using prettier-eslint package";
          homepage = "https://github.com/idahogurl/vs-code-prettier-eslint";
          license = lib.licenses.mit;
        };

        inferrinizzard.prettier-sql-vscode = {
          description = "Prettier SQL formatter for VS Code";
          homepage = "https://github.com/inferrinizzard/prettier-sql-vscode";
          license = lib.licenses.mit;
        };

        wallabyjs.quokka-vscode = {
          description = "Quokka.js - JavaScript and TypeScript playground in your editor";
          homepage = "https://quokkajs.com";
          license = lib.licenses.unfree;
        };

        syler.sass-indented = {
          description = "Indented Sass syntax Highlighting, Autocomplete & Formatter";
          homepage = "https://github.com/TheRealSyler/vscode-sass-indented";
          license = lib.licenses.mit;
        };

        mrmlnc.vscode-scss = {
          description = "SCSS IntelliSense for VS Code";
          homepage = "https://github.com/mrmlnc/vscode-scss";
          license = lib.licenses.mit;
        };

        moyu.snapcode = {
          description = "Take beautiful snapshots of your code";
          homepage = "https://marketplace.visualstudio.com/items?itemName=moyu.snapcode";
          license = lib.licenses.mit;
        };

        jannisx11.snowstorm = {
          description = "Minecraft Bedrock particle editor";
          homepage = "https://github.com/jannisx11/snowstorm";
          license = lib.licenses.mit;
        };

        minecraftcommands.syntax-mcfunction = {
          description = "Syntax highlighting for Minecraft .mcfunction files";
          homepage = "https://github.com/MinecraftCommands/vscode-syntax-mcfunction";
          license = lib.licenses.mit;
        };

        vosca.vscode-v-analyzer = {
          description = "V language support for VS Code powered by v-analyzer";
          homepage = "https://github.com/v-analyzer/v-analyzer";
          license = lib.licenses.mit;
        };

        uctakeoff.vscode-counter = {
          description = "Count lines of code in various programming languages";
          homepage = "https://github.com/uctakeoff/vscode-counter";
          license = lib.licenses.mit;
        };

        wallabyjs.wallaby-vscode = {
          description = "Wallaby.js - Intelligent Test Runner for JavaScript";
          homepage = "https://wallabyjs.com";
          license = lib.licenses.unfree;
        };

        p13xforever.language-x86-64-assembly = {
          description = "x86 and x86_64 Assembly syntax support for VS Code";
          homepage = "https://github.com/13xforever/x86_64-assembly-vscode";
          license = lib.licenses.mit;
        };

        rogalmic.vscode-xml-complete = {
          description = "XML language support with autocompletion based on XSD schema";
          homepage = "https://github.com/rogalmic/vscode-xml-complete";
          license = lib.licenses.mit;
        };

        blockceptionltd.blockceptionvscodeminecraftbedrockdevelopmentextension = {
          description = "An extension that provides code completion, validations, formatters, diagnostics, cheat-sheets, code-actions, creation of files, and development tools to help develop Minecraft Bedrock content";
          homepage = "https://github.com/Blockception/minecraft-bedrock-language-server";
          license = lib.licenses.bsd3;
        };
      })
  ]
