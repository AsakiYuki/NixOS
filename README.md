<p align="center">
  <img src="./logo/nix-snowflake-colours.svg" width="100" />
</p>

<h1 align="center">Asaki Yuki's NixOS</h1>

<p align="center">
  <em>Modular, multi-device NixOS configuration powered by Flakes</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/nixos-26.05-5277c3?style=for-the-badge&logo=nixos&logoColor=white&labelColor=000000" />
  <img src="https://img.shields.io/badge/license-GPL--3.0-green?style=for-the-badge&labelColor=000000" />
</p>

---

## 🖥️ Devices

| Target           | Description                                                       |
| :--------------- | :---------------------------------------------------------------- |
| `ideapad-slim-5` | Lenovo IdeaPad Slim 5 — Full desktop (KDE Plasma, Hyprland, Niri) |
| `home-server`    | Headless server (Forgejo, Nginx, Nextcloud, SearX, AdGuard Home)  |
| `wsl`            | WSL — Lightweight CLI environment                                 |

---

<!--
## 📎 Sub-flakes

This repo ships two standalone sub-flakes you can use independently in your own config:

### 🖱️ Custom Cursors (`flakes/cursors`)

A Home Manager module providing anime-themed cursor packs (Honkai, Wuthering Waves, etc.).

```nix
# flake.nix
{
  inputs.cursors.url = "github:asakiyuki/nixos?dir=flakes/cursors";

  # In your Home Manager config:
  # imports = [ inputs.cursors.homeModules.default ];
}
```

```nix
# home.nix
{
  theme.cursors = "wuthering-waves/denia";
}
```

> Available themes are listed in [`assets/cursors.json`](./assets/cursors.json).

### 📦 Custom Packages Overlay (`flakes/overlays`)

Adds some packages to nixpkgs.

```nix
# flake.nix
{
  inputs.asa-overlay.url = "github:asakiyuki/nixos?dir=flakes/overlays";
}
```

```nix
# configuration.nix
{
  nixpkgs.overlays = [ inputs.asa-overlay.overlays.default ];

  environment.systemPackages = with pkgs; [
    cider-2
    geode-cli
    # ...
  ];
}
```

> Available packages are listed in [`flakes/overlays/README.md`](./flakes/overlays/README.md). -->
