{
  lib,
  pkgs,
  ...
}: let
  jsonFormat = pkgs.formats.json {};

  opt = with lib; {
    global = {
      userSettings = mkOption {
        type = types.either types.path jsonFormat.type;
        default = {};
        example = {
          "files.autoSave" = "off";
          "[nix]"."editor.tabSize" = 2;
        };
        description = ''
          Configuration written to ${name}'s
          {file}`settings.json`.
          This can be a JSON object or a path to a custom JSON file.
        '';
      };

      userTasks = mkOption {
        type = types.either types.path jsonFormat.type;
        default = {};
        example = {
          version = "2.0.0";
          tasks = [
            {
              type = "shell";
              label = "Hello task";
              command = "hello";
            }
          ];
        };
        description = ''
          Configuration written to ${name}'s
          {file}`tasks.json`.
          This can be a JSON object or a path to a custom JSON file.
        '';
      };

      enableMcpIntegration = mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to integrate the MCP servers config from
          {option}`programs.mcp.servers` into
          {option}`${moduleName}.profiles.<name>.userMcp`.

          Note: Settings defined in {option}`programs.mcp.servers` are merged
          with {option}`${moduleName}.profiles.<name>.userMcp`, with ${name}
          settings taking precedence.
        '';
      };

      userMcp = mkOption {
        type = types.either types.path jsonFormat.type;
        default = {};
        example.servers.Github.url = "https://api.githubcopilot.com/mcp/";
        description = ''
          Configuration written to ${name}'s
          {file}`mcp.json`.
          This can be a JSON object or a path to a custom JSON file.
        '';
      };

      keybindings = mkOption {
        type = types.either types.path (
          types.listOf (
            types.submodule {
              freeformType = jsonFormat.type;
              options = {
                key = mkOption {
                  type = types.str;
                  example = "ctrl+c";
                  description = "The key or key-combination to bind.";
                };

                command = mkOption {
                  type = types.str;
                  example = "editor.action.clipboardCopyAction";
                  description = "The VS Code command to execute.";
                };

                when = mkOption {
                  type = types.nullOr (types.str);
                  default = null;
                  example = "textInputFocus";
                  description = "Optional context filter.";
                };

                args = mkOption {
                  type = types.nullOr (jsonFormat.type);
                  default = null;
                  example = {
                    direction = "up";
                  };
                  description = "Optional arguments for a command.";
                };
              };
            }
          )
        );
        default = [];
        example = [
          {
            key = "ctrl+c";
            command = "editor.action.clipboardCopyAction";
            when = "textInputFocus";
          }
        ];
        description = ''
          Keybindings written to ${name}'s
          {file}`keybindings.json`.
          This can be a JSON object or a path to a custom JSON file.
        '';
      };

      extensions = mkOption {
        type = types.listOf types.package;
        default = [];
        example = literalExpression "[ pkgs.vscode-extensions.bbenoist.nix ]";
        description = ''
          The extensions ${name} should be started with.
        '';
      };

      languageSnippets = mkOption {
        inherit (jsonFormat) type;
        default = {};
        example = {
          haskell = {
            fixme = {
              prefix = ["fixme"];
              body = ["$LINE_COMMENT FIXME: $0"];
              description = "Insert a FIXME remark";
            };
          };
        };
        description = "Defines user snippets for different languages.";
      };

      globalSnippets = mkOption {
        inherit (jsonFormat) type;
        default = {};
        example = {
          fixme = {
            prefix = ["fixme"];
            body = ["$LINE_COMMENT FIXME: $0"];
            description = "Insert a FIXME remark";
          };
        };
        description = "Defines global user snippets.";
      };

      enableUpdateCheck = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = ''
          Whether to enable update checks/notifications.
          Can only be set for the default profile, but
          it applies to all profiles.
        '';
      };

      enableExtensionUpdateCheck = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = ''
          Whether to enable update notifications for extensions.
          Can only be set for the default profile, but
          it applies to all profiles.
        '';
      };
    };
  };
in {
  options.programs = {
    vscode = opt;
    vscodium = opt;
  };
}
