---
name: nixos-config
description: Work on this repository's NixOS and Home Manager flake, host/device modules, package overlays, and source-data updaters.
---

# NixOS repository work

Use this skill for changes in this repository. Read the root [README](../../../README.md) for the configuration names and command examples; inspect the target module's imports before changing it.

## Repository structure

- `flake.nix` defines inputs and exports configurations assembled in `configs/`.
- `devices/` holds machine-specific hardware and system settings. `host/` holds shared desktop, server, and macOS roles. `users/` holds user and account setup.
- `options/` declares custom options. `modules/` implements reusable NixOS and Home Manager behavior. Host and device files select these through their import lists.
- `overlays/packages/` builds custom packages and generated extension packages.
- `assets/sources.json` is the shared database for fetched artifacts and metadata. `scripts/` contains its updaters and add-entry tools.

## Source data and overlays

- Keep the source-data shape documented in the README. Cursors use nested `cursors.<category>.<name>` data, while the public option remains `category/name`.
- `flake.nix` reads `assets/sources.json` once into the Nix identifier `source-data`. Preserve that single read and propagate it through configuration helpers. Nix modules use `lib.source-data`; package overlays require the `sources` argument.
- Overlay imports happen through `overlays/inputs-overlays.nix` in both the NixOS/Home Manager module path and the dev shell. When changing its arguments, update every caller, including `configs/dev.nix`.
- Millennium names stay in source data as published. Its package overlay maps dots in IDs to underscores for Nix attribute names; use the same mapping when adding or looking up those attributes.
- When changing a database category or field, update every Nix consumer, updater, and add-entry tool that reads or writes it.

## Choosing where to make a change

- Put machine-only behavior under that machine's `devices/<name>/` tree.
- Put behavior shared by a host role under `host/desktop/`, `host/server/`, or `host/macos/` as appropriate.
- Put reusable option declarations in `options/` and reusable module behavior in `modules/`.
- Put package derivations in `overlays/packages/`; pass the shared database through `sources` rather than reading `assets/sources.json` again inside an overlay.
- Follow nearby import and naming patterns instead of adding an abstraction for a single use.

## Validation and update scripts

For Nix changes, parse edited expressions and evaluate the narrowest affected flake output first. Useful commands include:

```sh
nix-instantiate --parse path/to/file.nix
nix eval '.#nixosConfigurations.<name>.config.system.build.toplevel.drvPath' --raw
nix eval '.#homeConfigurations."asakiyuki@Macbook-Air-M5".activationPackage.drvPath' --raw
```

Use `nix develop` for the repository's Bun and `vsce` tools. Run only the updater relevant to the change. Updaters use the network and can write `assets/sources.json` and root-level `*-commit.txt` reports; inspect and preserve existing work before running them. `.github/pkgs-update.sh` commits updates itself, so use individual `bun run check-...` commands for ordinary checks. A macOS activation package targets `aarch64-darwin`; evaluation on Linux does not imply it can be built there.

Do not read secret values from `.env`, `assets/secrets/`, or local secret files while documenting or changing unrelated configuration. Follow the existing secret references and module declarations instead.
