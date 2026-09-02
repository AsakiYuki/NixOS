{
  pkgs,
  lib,
  ...
}: let
  extensions = lib.importJSON ../../assets/vscode.extensions.json;

  buildVscodeMarketplaceExtension = {
    ref,
    meta,
  }: let
    extId = "${ref.publisher}.${ref.name}";
    data = extensions.${extId};
  in (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = ref // data;
    meta = {downloadPage = "https://marketplace.visualstudio.com/items?itemName=${extId}";} // meta;
  });
in {
  jbro.vscode-default-keybindings = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "jbro";
      name = "vscode-default-keybindings";
    };
    meta = {
      description = "VSCode Default Keybindings is a keymap that enables you to load VSCode's default keybindings from another OS. Eg. use Mac keybindings on Windows.";
      homepage = "https://github.com/jbro/vscode-default-keybindings";
      license = lib.licenses.unlicense;
    };
  };

  geodesdk.geode = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "geodesdk";
      name = "geode";
    };
    meta = {
      description = "Utilities for the Geode Geometry Dash modding framework";
      homepage = "https://github.com/geode-sdk/vscode";
      license = lib.licenses.mit;
    };
  };

  theqtcompany.qt-qml = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "theqtcompany";
      name = "qt-qml";
    };
    meta = {
      description = "Qt QML Support";
      homepage = "https://github.com/qt-labs/vscodeext";
      license = lib.licenses.lgpl3Only;
    };
  };

  bbenoist.qml = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "bbenoist";
      name = "qml";
    };
    meta = {
      description = "QML language support for Visual Studio Code";
      homepage = "https://github.com/bbenoist/vscode-qml";
      license = lib.licenses.mit;
    };
  };

  adrianwilczynski.alpine-js-intellisense = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "adrianwilczynski";
      name = "alpine-js-intellisense";
    };
    meta = {
      description = "Simple IntelliSense & Snippets for Alpine.js framework.";
      homepage = "https://github.com/AdrianWilczynski/AlpineIntelliSense";
      license = lib.licenses.mit;
    };
  };

  edwinkofler.vscode-assorted-languages = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "edwinkofler";
      name = "vscode-assorted-languages";
    };
    meta = {
      description = "Assorted languages support for Visual Studio Code";
      homepage = "https://github.com/edwinkofler/vscode-assorted-languages";
      license = lib.licenses.mit;
    };
  };

  astro-build.astro-vscode = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "astro-build";
      name = "astro-vscode";
    };
    meta = {
      description = "Language support for Astro";
      homepage = "https://github.com/withastro/astro";
      license = lib.licenses.mit;
    };
  };

  formulahendry.auto-rename-tag = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "formulahendry";
      name = "auto-rename-tag";
    };
    meta = {
      description = "Auto rename paired HTML/XML tag";
      homepage = "https://github.com/formulahendry/vscode-auto-rename-tag";
      license = lib.licenses.mit;
    };
  };

  thekalinga.bootstrap4-vscode = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "thekalinga";
      name = "bootstrap4-vscode";
    };
    meta = {
      description = "Bootstrap 4 snippets based on documentation + Font awesome 4 + Font Awesome 5 Free & Pro snippets";
      homepage = "https://github.com/1tontech/bootstrap4-snippets";
      license = lib.licenses.mit;
    };
  };

  ms-vscode.cpp-devtools = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "ms-vscode";
      name = "cpp-devtools";
    };
    meta = {
      description = "C++ DevTools for Visual Studio Code";
      homepage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpp-devtools";
      license = lib.licenses.unfree;
    };
  };

  ultram4rine.vscode-choosealicense = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "ultram4rine";
      name = "vscode-choosealicense";
    };
    meta = {
      description = "Choose a license for your project in VS Code";
      homepage = "https://github.com/ultram4rine/vscode-choosealicense";
      license = lib.licenses.mit;
    };
  };

  openai.chatgpt = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "openai";
      name = "chatgpt";
    };
    meta = {
      description = "ChatGPT - The official OpenAI extension for VS Code";
      homepage = "https://marketplace.visualstudio.com/items?itemName=openai.chatgpt";
      license = lib.licenses.unfree;
    };
  };

  zokugun.cron-tasks = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "zokugun";
      name = "cron-tasks";
    };
    meta = {
      description = "Run tasks on a schedule";
      homepage = "https://github.com/zokugun/vscode-cron-tasks";
      license = lib.licenses.mit;
    };
  };

  mrmlnc.vscode-duplicate = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "mrmlnc";
      name = "vscode-duplicate";
    };
    meta = {
      description = "Ability to duplicate files in VS Code";
      homepage = "https://github.com/mrmlnc/vscode-duplicate";
      license = lib.licenses.mit;
    };
  };

  tobermory.es6-string-html = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "tobermory";
      name = "es6-string-html";
    };
    meta = {
      description = "ES6 Template Literals editor with Syntax Highlighting";
      homepage = "https://github.com/tobermory/es6-string-html";
      license = lib.licenses.mit;
    };
  };

  ctcuff.font-preview = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "ctcuff";
      name = "font-preview";
    };
    meta = {
      description = "Preview fonts in VS Code";
      homepage = "https://github.com/ctcuff/vscode-font-preview";
      license = lib.licenses.mit;
    };
  };

  ecmel.vscode-html-css = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "ecmel";
      name = "vscode-html-css";
    };
    meta = {
      description = "HTML id and class attribute completion for Visual Studio Code";
      homepage = "https://github.com/ecmel/vscode-html-css";
      license = lib.licenses.mit;
    };
  };

  pushqrdx.inline-html = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "pushqrdx";
      name = "inline-html";
    };
    meta = {
      description = "Inline HTML syntax highlighting in JS/TS template literals";
      homepage = "https://github.com/pushqrdx/vscode-inline-html";
      license = lib.licenses.mit;
    };
  };

  lllllllqw.jsdoc = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "lllllllqw";
      name = "jsdoc";
    };
    meta = {
      description = "JSDoc support for VS Code";
      homepage = "https://marketplace.visualstudio.com/items?itemName=lllllllqw.jsdoc";
      license = lib.licenses.mit;
    };
  };

  joshuapoehls.json-escaper = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "joshuapoehls";
      name = "json-escaper";
    };
    meta = {
      description = "Escape and unescape troublesome characters in JSON string values";
      homepage = "https://github.com/joshuapoehls/vscode-json-escaper";
      license = lib.licenses.mit;
    };
  };

  mojang-studios.minecraft-debugger = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "mojang-studios";
      name = "minecraft-debugger";
    };
    meta = {
      description = "Minecraft Debugger for Visual Studio Code";
      homepage = "https://marketplace.visualstudio.com/items?itemName=mojang-studios.minecraft-debugger";
      license = lib.licenses.unfree;
    };
  };

  zz5840.minecraft-lang-colorizer = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "zz5840";
      name = "minecraft-lang-colorizer";
    };
    meta = {
      description = "Colorizer for Minecraft .lang files";
      homepage = "https://marketplace.visualstudio.com/items?itemName=zz5840.minecraft-lang-colorizer";
      license = lib.licenses.mit;
    };
  };

  stevertus.mcscript = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "stevertus";
      name = "mcscript";
    };
    meta = {
      description = "MCScript language support for VS Code";
      homepage = "https://github.com/Stevertus/mcscript";
      license = lib.licenses.mit;
    };
  };

  cardinal90.multi-cursor-case-preserve = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "cardinal90";
      name = "multi-cursor-case-preserve";
    };
    meta = {
      description = "Preserves case when editing with multiple cursors";
      homepage = "https://github.com/Cardinal90/multi-cursor-case-preserve";
      license = lib.licenses.mit;
    };
  };

  cweijan.vscode-mysql-client2 = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "cweijan";
      name = "vscode-mysql-client2";
    };
    meta = {
      description = "Database Client for VS Code - supports MySQL, PostgreSQL, SQLite, Redis, MongoDB and more";
      homepage = "https://github.com/cweijan/vscode-database-client";
      license = lib.licenses.unfree;
    };
  };

  code-nature.nilesoft-shell-file-formatter = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "code-nature";
      name = "nilesoft-shell-file-formatter";
    };
    meta = {
      description = "Nilesoft Shell file formatter for VS Code";
      homepage = "https://marketplace.visualstudio.com/items?itemName=code-nature.nilesoft-shell-file-formatter";
      license = lib.licenses.mit;
    };
  };

  jinxdash.prettier-rust = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "jinxdash";
      name = "prettier-rust";
    };
    meta = {
      description = "Prettier Rust formatter plugin";
      homepage = "https://github.com/jinxdash/prettier-plugin-rust";
      license = lib.licenses.mit;
    };
  };

  rvest.vs-code-prettier-eslint = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "rvest";
      name = "vs-code-prettier-eslint";
    };
    meta = {
      description = "A Visual Studio Code Extension to format JavaScript and TypeScript code using prettier-eslint package";
      homepage = "https://github.com/idahogurl/vs-code-prettier-eslint";
      license = lib.licenses.mit;
    };
  };

  inferrinizzard.prettier-sql-vscode = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "inferrinizzard";
      name = "prettier-sql-vscode";
    };
    meta = {
      description = "Prettier SQL formatter for VS Code";
      homepage = "https://github.com/inferrinizzard/prettier-sql-vscode";
      license = lib.licenses.mit;
    };
  };

  wallabyjs.quokka-vscode = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "wallabyjs";
      name = "quokka-vscode";
    };
    meta = {
      description = "Quokka.js - JavaScript and TypeScript playground in your editor";
      homepage = "https://quokkajs.com";
      license = lib.licenses.unfree;
    };
  };

  syler.sass-indented = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "syler";
      name = "sass-indented";
    };
    meta = {
      description = "Indented Sass syntax Highlighting, Autocomplete & Formatter";
      homepage = "https://github.com/TheRealSyler/vscode-sass-indented";
      license = lib.licenses.mit;
    };
  };

  mrmlnc.vscode-scss = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "mrmlnc";
      name = "vscode-scss";
    };
    meta = {
      description = "SCSS IntelliSense for VS Code";
      homepage = "https://github.com/mrmlnc/vscode-scss";
      license = lib.licenses.mit;
    };
  };

  moyu.snapcode = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "moyu";
      name = "snapcode";
    };
    meta = {
      description = "Take beautiful snapshots of your code";
      homepage = "https://marketplace.visualstudio.com/items?itemName=moyu.snapcode";
      license = lib.licenses.mit;
    };
  };

  jannisx11.snowstorm = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "jannisx11";
      name = "snowstorm";
    };
    meta = {
      description = "Minecraft Bedrock particle editor";
      homepage = "https://github.com/jannisx11/snowstorm";
      license = lib.licenses.mit;
    };
  };

  minecraftcommands.syntax-mcfunction = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "minecraftcommands";
      name = "syntax-mcfunction";
    };
    meta = {
      description = "Syntax highlighting for Minecraft .mcfunction files";
      homepage = "https://github.com/MinecraftCommands/vscode-syntax-mcfunction";
      license = lib.licenses.mit;
    };
  };

  vosca.vscode-v-analyzer = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "vosca";
      name = "vscode-v-analyzer";
    };
    meta = {
      description = "V language support for VS Code powered by v-analyzer";
      homepage = "https://github.com/v-analyzer/v-analyzer";
      license = lib.licenses.mit;
    };
  };

  uctakeoff.vscode-counter = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "uctakeoff";
      name = "vscode-counter";
    };
    meta = {
      description = "Count lines of code in various programming languages";
      homepage = "https://github.com/uctakeoff/vscode-counter";
      license = lib.licenses.mit;
    };
  };

  wallabyjs.wallaby-vscode = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "wallabyjs";
      name = "wallaby-vscode";
    };
    meta = {
      description = "Wallaby.js - Intelligent Test Runner for JavaScript";
      homepage = "https://wallabyjs.com";
      license = lib.licenses.unfree;
    };
  };

  p13xforever.language-x86-64-assembly = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "13xforever";
      name = "language-x86-64-assembly";
    };
    meta = {
      description = "x86 and x86_64 Assembly syntax support for VS Code";
      homepage = "https://github.com/13xforever/x86_64-assembly-vscode";
      license = lib.licenses.mit;
    };
  };

  rogalmic.vscode-xml-complete = buildVscodeMarketplaceExtension {
    ref = {
      publisher = "rogalmic";
      name = "vscode-xml-complete";
    };
    meta = {
      description = "XML language support with autocompletion based on XSD schema";
      homepage = "https://github.com/rogalmic/vscode-xml-complete";
      license = lib.licenses.mit;
    };
  };
}
