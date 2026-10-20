# NixOS configuration

This repository contains NixOS and Home Manager configurations, package overlays, and scripts that maintain package and extension source data.

## Configurations

The flake exports these NixOS configurations:

| Flake attribute | Purpose |
| --- | --- |
| `nixosConfigurations.ideapad-slim-5` | Desktop/laptop configuration |
| `nixosConfigurations.msi-sayu` | Sayu's system configuration |
| `nixosConfigurations.home-server` | Home server |
| `nixosConfigurations.wsl` | WSL configuration |

It also exports the standalone Home Manager configuration `homeConfigurations."asakiyuki@Macbook-Air-M5"`. Each NixOS configuration loads Home Manager; host and device modules add the user-specific Home Manager configuration.

Build or evaluate a configuration with its flake attribute. For example:

```sh
nix eval '.#nixosConfigurations.ideapad-slim-5.config.system.build.toplevel.drvPath' --raw
nix build '.#nixosConfigurations.ideapad-slim-5.config.system.build.toplevel'
```

On the matching NixOS machine, switch to a configuration with:

```sh
sudo nixos-rebuild switch --flake .#ideapad-slim-5
```

Evaluate the standalone macOS Home Manager generation with:

```sh
nix eval '.#homeConfigurations."asakiyuki@Macbook-Air-M5".activationPackage.drvPath' --raw
```

Building that activation package requires a builder for `aarch64-darwin`.

## Repository layout

| Path | Contents |
| --- | --- |
| `flake.nix`, `configs/` | Flake inputs and exported configurations |
| `devices/` | Hardware, services, and system-specific settings |
| `host/` | Shared desktop, server, and macOS host modules |
| `users/` | User and account configuration |
| `modules/` | Reusable NixOS and Home Manager implementation modules |
| `options/` | Custom module options and their configuration |
| `overlays/packages/` | Package, extension, font, and Millennium overlays |
| `assets/sources.json` | Shared source, version, hash, and metadata database |
| `scripts/` | Source-data updaters and add-extension tools |
| `AGENTS.md` | Canonical repository instructions for AI coding agents |
| `CLAUDE.md` | Claude Code entry point; imports `AGENTS.md` |
| `.github/` | Scheduled update and mirror workflows |

AI agent instructions live in `AGENTS.md`. `CLAUDE.md` imports that file so Claude Code uses the same repository guidance without a duplicate copy. Other agents should read `AGENTS.md` when they support that convention; tools with a different instruction-file setting can be pointed to it explicitly.

The `options/` tree defines the repository's custom options. The `modules/` tree implements reusable program behavior. Device and host files select and configure those modules.

## Source database

`assets/sources.json` keeps fetched source information in one file:

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

Cursor options retain the `category/name` form, for example `wuthering-waves/denia`.

The flake reads this database once as `source-data` and passes it to configuration helpers and package overlays. Nix modules access it through `lib.source-data`; package overlays receive it as `sources`.

## Development and updates

Enter the development shell and install the JavaScript dependencies:

```sh
nix develop
bun install --frozen-lockfile
```

Run an individual updater from the shell:

```sh
bun run check-packages-update
bun run check-proton-update
bun run check-vscode-extensions-update
bun run check-browser-extensions-update
bun run check-millennium-update
bun run check-millennium-settings
```

Updaters contact their source services and write changes directly to `assets/sources.json`; they do not create report files. The `.github/pkgs-update.sh` workflow helper runs the full updater suite, compares the database with `HEAD`, and creates one commit for the changed source data. Its subject includes counts of changed programs, Proton runtimes, and extensions; the commit body lists their names. It refuses to run when `assets/sources.json` already has local changes.

The `add-firefox-addons`, `add-chrome-extensions`, and `add-vscode-extensions` scripts add entries to the corresponding source database section. Check each script in `scripts/tools/` for its accepted input format.

GitHub Actions periodically refreshes flake inputs and package/extension data. The Forgejo workflow mirrors pushes to the configured remote.
