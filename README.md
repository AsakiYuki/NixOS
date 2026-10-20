# NixOS configuration

NixOS and Home Manager configurations, package overlays, and scripts for maintaining package and extension source data.

## Contents

- [Configurations](#configurations)
- [Repository layout](#repository-layout)
- [Source database](#source-database)
- [Development and updates](#development-and-updates)
- [AI agent instructions](#ai-agent-instructions)

## Configurations

### NixOS

| Flake attribute | Purpose |
| --- | --- |
| `nixosConfigurations.ideapad-slim-5` | Laptop configuration |
| `nixosConfigurations.msi-sayu` | Sayu's system configuration |
| `nixosConfigurations.home-server` | Home server |
| `nixosConfigurations.wsl` | WSL configuration |

Each NixOS configuration loads Home Manager. Host and device modules select and configure the user's Home Manager modules.

Evaluate or build a configuration:

```sh
nix eval '.#nixosConfigurations.ideapad-slim-5.config.system.build.toplevel.drvPath' --raw
nix build '.#nixosConfigurations.ideapad-slim-5.config.system.build.toplevel'
```

On the matching NixOS machine, activate it with:

```sh
sudo nixos-rebuild switch --flake .#ideapad-slim-5
```

### Standalone Home Manager

The flake also exports `homeConfigurations."asakiyuki@Macbook-Air-M5"`:

```sh
nix eval '.#homeConfigurations."asakiyuki@Macbook-Air-M5".activationPackage.drvPath' --raw
```

Building this activation package requires a builder for `aarch64-darwin`.

## Repository layout

| Path | Purpose |
| --- | --- |
| `flake.nix`, `configs/` | Flake inputs and exported configurations |
| `devices/` | Hardware and machine-specific settings |
| `host/` | Shared desktop, server, and macOS modules |
| `users/` | User and account configuration |
| `options/` | Custom NixOS and Home Manager options |
| `modules/` | Reusable module implementations |
| `overlays/packages/` | Package, extension, font, and Millennium overlays |
| `assets/sources.json` | Shared package and extension source database |
| `scripts/` | Database updaters and add-entry tools |
| `.github/` | Scheduled update and mirror workflows |

Custom options are declared under `options/`; their reusable behavior is implemented in `modules/`. Host and device configurations select and set those options.

## Source database

`assets/sources.json` stores versions, source URLs, hashes, and related metadata in one place:

```text
cursors.<category>.<name>
packages.programs.<package>
packages.wine.<proton>
extensions.firefox.<addon>
extensions.chrome.<extension>
extensions.vscode.<publisher>.<extension>
extensions.millennium.plugins.<plugin>
extensions.millennium.themes.<theme>
```

Cursor options keep the `category/name` form, for example `wuthering-waves/denia`.

The flake reads the database once as `source-data` and passes it to configuration helpers and package overlays. Nix modules use `lib.source-data`; package overlays receive it as `sources`.

## Development and updates

Enter the development shell and install dependencies:

```sh
nix develop
bun install --frozen-lockfile
```

Run the updater you need:

```sh
bun run check-packages-update
bun run check-proton-update
bun run check-vscode-extensions-update
bun run check-browser-extensions-update
bun run check-millennium-update
bun run check-millennium-settings
```

Updaters contact their source services and write changes directly to `assets/sources.json`. They do not create report files. The `.github/pkgs-update.sh` helper runs the complete suite and creates one commit when the database changes. The commit subject counts changed programs, Proton runtimes, and extensions; its body lists their names. The helper stops if the database already has local changes.

The `add-firefox-addons`, `add-chrome-extensions`, and `add-vscode-extensions` tools add entries to the database. Their accepted input formats are documented in `scripts/tools/`.

GitHub Actions periodically updates flake inputs and package or extension data. The Forgejo workflow mirrors pushes to the configured remote.

## AI agent instructions

[`AGENTS.md`](AGENTS.md) is the canonical guide for coding agents. [`CLAUDE.md`](CLAUDE.md) points Claude Code to the same instructions. Other agents should read `AGENTS.md` when supported, or be configured to use it explicitly.
